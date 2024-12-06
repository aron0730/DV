/*
 * Copyright 2023 Wolley Inc.
 * TRIM.c
 *
 *  Created on:  August 28, 2023
 *      Author: Aaron
 */

// self-contained header
#include "RWMgr.h"
#include "RWMgr_private.h"

#if (CONFIG_BUILD_MODE == BUILD_MODE_MP)
    // #include "DebugLog.h"
    #include "GlobVar0.h"
    #include "EventDefine.h"
    #include "EventLogFunctionIDX.h"
    #include "DebugLog.h"
#endif

#if (CONFIG_BUILD_MODE == BUILD_MODE_MP)
    #pragma default_function_attributes = @ ".CORE0_TRIM"
#endif

#define TRIM_DEBUG_MSG (0)

#if TRIM_DEBUG_MSG
static u32 debug_lba = 0x3f75917;
static u8 debug_hand_print = FALSE;
static u8 debug_getnvme_print = FALSE;
static u8 debug_in_out_print = FALSE;
static u8 debug_buff_print = FALSE;
static u8 debug_round_print = FALSE;
static u8 debug_bufflist_print = FALSE;
static u8 debug_fifo_print = FALSE;
static u64 debug_round = 0;
static u32 debug_nv_cnt = 0;
static u64 SPEC_ROUND = 0;

#endif

s8 TRIM_AnalyzeRange_init(void *handle, env_addr_t *start_range);
s8 TRIM_CallTable_Done(void *handle);
s8 TRIM_CallTableL1_F(void *handle, LSA_union left, LSA_union right);
s8 TRIM_CheckExit_table(void *handle);
s8 TRIM_CheckExit_rw(void *handle);
s8 TRIM_Exit(void *handle);
s8 TRIM_AnalyzeRange(void *handle);
s8 TRIM_CallTableMgrCrossL0(void *handle);
s8 TRIM_CallTableL1_PFP(void *handle);
s8 TRIM_CallTableL1_PF(void *handle);
s8 TRIM_CallTableL1_PP(void *handle);
s8 TRIM_CallTableL1_FP(void *handle);

static u32 max(u32 a, u32 b) {
    return a >= b ? a : b;
}

static u32 min(u32 a, u32 b) {
    return a <= b ? a : b;
}

void SetHeadProceed(void *handle) {
    // This function will make rw_fifo forward
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u16 ctag = h->TRIM.NV_list.ID[h->TRIM.cur_cmd_idx];
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
    insert_completion_ctag(h->NVMe_handle, h->FCL_handle, ctag);
#elif (CONFIG_BUILD_MODE == BUILD_MODE_MP)
    // FIXME(aaron): ctag in MP mode?
#endif
    h->rw_fifo[h->rw_ctrl.head].valid = FALSE;
    INC_QUEUE_PTR(h->rw_ctrl.head, RW_FIFO_DEPTH);
    h->rw_ctrl.cnt--;
}

s8 TRIM_SetRWMgrCBData(RWMgr_handle_t *h, TRIM_cb_fn func) {
    h->rw_cb.handle = NULL;
    h->rw_cb.caller_cb = (RWMgr_cb_fn)func;
    h->rw_cb.caller_data = (void*)(h);
    return STATUS_OK;
}

s8 TRIM_SetTableCBData(RWMgr_handle_t *h, TRIM_cb_fn func) {
    h->tb_cb.handle = h->TableMgr_handle;
    h->tb_cb.caller_cb = (TableMgr_cb_fn)func;
    h->tb_cb.caller_data = (void*)(h);
    return STATUS_OK;
}

s8 TRIM_CallTable_Done(void *handle) {
    // When this round nvme is finished, call function make TableMgr to program
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    TRIM_SetTableCBData(h, TRIM_Exit);
    TableMgr_TRIM_Done(h->TableMgr_handle, &h->tb_cb);
    return STATUS_OK;
}

s8 TRIM_LSATransShort(LSA_union hand, LSA_Short_union *L1_idx) {
    L1_idx->lsa_short.L0_idx = hand.lsa.L0_idx;
    L1_idx->lsa_short.L0_oft = hand.lsa.L0_oft;
    return STATUS_OK;
}

s8 TRIM_SetSubHand(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_union L0_sub_left = h->TRIM.hand.left;
    LSA_union L0_sub_right = h->TRIM.hand.right;
    LSA_union L1_sub_left = h->TRIM.hand.left;
    LSA_union L1_sub_right = h->TRIM.hand.right;
    L0_sub_left.lsa.L0_oft = END_OFT;
    L0_sub_left.lsa.L1_oft = END_OFT;
    L0_sub_right.lsa.L0_oft = START_OFT;
    L0_sub_right.lsa.L1_oft = START_OFT;
    L1_sub_left.lsa.L1_oft = END_OFT;
    L1_sub_right.lsa.L1_oft = START_OFT;
    h->TRIM.hand.L0_sub_left = L0_sub_left;
    h->TRIM.hand.L0_sub_right = L0_sub_right;
    h->TRIM.hand.L1_sub_left = L1_sub_left;
    h->TRIM.hand.L1_sub_right = L1_sub_right;
    return STATUS_OK;
}

s8 TRIM_CallRW512B_RMW(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u32 start, len;
    u32 left_512B = h->TRIM.hand.left_512B;
    u32 right_512B = h->TRIM.hand.right_512B;
    u32 left_512B_idx = left_512B % NUM_OF_512B_PER_4K;
    u32 right_512B_idx = right_512B % NUM_OF_512B_PER_4K;
    // According to range type to decide how to call RWMgr
    switch (h->TRIM.type_512B) {
        case INIT_512B:
            break;

        case P_512B:
            start = left_512B;
            len = right_512B - start + 1;
            TRIM_SetRWMgrCBData(h, TRIM_CheckExit_rw);
            h->TRIM.flag.rw_send_cnt++;
            RWMgr_Insert512BTrim(handle, start, len, &h->rw_cb);
            if (h->hmb_en) {
                h->sub_state = W_STATE_HMB_START;
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                RWMgr_HostWriteProc_withHMB(h);  //FIXME(aaron): watting HMB mode
#endif
            } else {
                RWMgr_HostWriteProc(h);
            }
            return STATUS_OK;

        case PP_512B:

            // left
            start = left_512B;
            len = NUM_OF_512B_PER_4K - (start % NUM_OF_512B_PER_4K);
            TRIM_SetRWMgrCBData(h, TRIM_CheckExit_rw);
            h->TRIM.flag.rw_send_cnt++;
            RWMgr_Insert512BTrim(handle, start, len, &h->rw_cb);

            // right
            start = (right_512B & 0xfffffff8);
            len = right_512B - start + 1;
            TRIM_SetRWMgrCBData(h, TRIM_CheckExit_rw);
            h->TRIM.flag.rw_send_cnt++;
            RWMgr_Insert512BTrim(handle, start, len, &h->rw_cb);
            if (h->hmb_en) {
                h->sub_state = W_STATE_HMB_START;
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                RWMgr_HostWriteProc_withHMB(h);  //FIXME(aaron): watting HMB mode
#endif
            } else {
                RWMgr_HostWriteProc(h);
            }
            return STATUS_OK;

        case PFP_512B:
            if ((left_512B_idx == FIRST_512B_INDEX) &&
                (right_512B_idx == LAST_512B_INDEX)) {
                TRIM_CheckExit_rw(handle);
                return STATUS_OK;
            }
            /* Left hand part */
            if (left_512B_idx != FIRST_512B_INDEX) {
                // Not alignment! Call RWMgr
                start = left_512B;
                len = NUM_OF_512B_PER_4K - (start % NUM_OF_512B_PER_4K);
                TRIM_SetRWMgrCBData(h, TRIM_CheckExit_rw);
                h->TRIM.flag.rw_send_cnt++;
                RWMgr_Insert512BTrim(handle, start, len, &h->rw_cb);
            }

            /* Right hand part */
            if (right_512B_idx != LAST_512B_INDEX) {
                // Not alignment! Call RWMgr
                start = (right_512B & 0xfffffff8);
                len = right_512B - start + 1;
                TRIM_SetRWMgrCBData(h, TRIM_CheckExit_rw);
                h->TRIM.flag.rw_send_cnt++;
                RWMgr_Insert512BTrim(handle, start, len, &h->rw_cb);
            }

            if (h->TRIM.flag.rw_send_cnt != 0) {
                if (h->hmb_en) {
                    h->sub_state = W_STATE_HMB_START;
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                RWMgr_HostWriteProc_withHMB(h);  //FIXME(aaron): watting HMB mode
#endif
                } else {
                    RWMgr_HostWriteProc(h);
                }
            }
            return STATUS_OK;
    }
    return STATUS_OK;
}

s8 TRIM_SetSubHand_512B(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u32 start, len;
    u32 left_512B = h->TRIM.hand.left_512B;
    u32 right_512B = h->TRIM.hand.right_512B;
    s32 left = left_512B / NUM_OF_512B_PER_4K;
    s32 right = right_512B / NUM_OF_512B_PER_4K;
    u32 left_512B_idx = left_512B % NUM_OF_512B_PER_4K;
    u32 right_512B_idx = right_512B % NUM_OF_512B_PER_4K;
    h->TRIM.hand.left_512B_idx = left_512B_idx;
    h->TRIM.hand.right_512B_idx = right_512B_idx;

    // Select the range type of the lba in leftmost sector and rightmost sector
    if ((right_512B - left_512B < NUM_OF_512B_PER_4K - 1) && (right == left)) {
        h->TRIM.type_512B = P_512B;
    } else if ((right - left == 1) &&  \
        (right_512B_idx != LAST_512B_INDEX) &&  \
        (left_512B_idx != FIRST_512B_INDEX)) {
        h->TRIM.type_512B = PP_512B;
    } else if (right - left >= 0) {
        h->TRIM.type_512B = PFP_512B;
    } else {
        D_ASSERT(0);
    }

    switch (h->TRIM.type_512B) {
        case INIT_512B:
            break;

        case P_512B:
            break;

        case PP_512B:
            break;

        case PFP_512B:

            /* Left hand part */
            if (left_512B_idx == FIRST_512B_INDEX) {
                // Alignment! update hand for 4K in handler
                h->TRIM.hand.left.val = left;
            } else {
                // Not alignment!
                start = left_512B;
                len = NUM_OF_512B_PER_4K - (start % NUM_OF_512B_PER_4K);

                // Update hand for 4K in handler
                h->TRIM.hand.left.val = (start + len) / NUM_OF_512B_PER_4K;
            }

            /* Right hand part */
            if (right_512B_idx == LAST_512B_INDEX) {
                // Alignment! update hand for 4K in handler
                h->TRIM.hand.right.val = right;
            } else {
                // Not alignment!
                start = (right_512B & 0xfffffff8);
                len = right_512B - start + 1;

                // Update hand for 4K in handler
                h->TRIM.hand.right.val = \
                    (right_512B - len) / NUM_OF_512B_PER_4K;
            }

            // After setting 4k mode hand, call this func to set subhand
            TRIM_SetSubHand(handle);
    }
    return STATUS_OK;
}

s8 TRIM_CallTableMgrExactL0(void *handle, LSA_union left, LSA_union right) {
    // This function will trim continous L0
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u16 L0_idx = left.lsa.L0_idx;
    u32 len = right.lsa.L0_idx - left.lsa.L0_idx + 1;
    h->TRIM.flag.tb_send_cnt++;
    TRIM_SetTableCBData(h, TRIM_CheckExit_table);
    if (h->hmb_en) {
        TableMgr_TRIM_L0_HMB(h->TableMgr_handle, L0_idx, len, &h->tb_cb);
    } else {
        TableMgr_TRIM_L0(h->TableMgr_handle, L0_idx, len, &h->tb_cb);
    }
    return STATUS_OK;
}

s8 TRIM_CallTableMgrExactL1(void *handle, LSA_union left, LSA_union right) {
    TRIM_CallTableL1_F(handle, left, right);
    return STATUS_OK;
}

s8 TRIM_CallTableMgrCrossLSA(void *handle, LSA_union left, LSA_union right) {
    // This function will trim continous lsa
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u32 len = right.val - left.val + 1;
    h->TRIM.flag.tb_send_cnt++;
    TRIM_SetTableCBData(h, TRIM_CheckExit_table);
    if (h->hmb_en) {
        TableMgr_TRIM_LSA_HMB(h->TableMgr_handle,
                          left,
                          len,
                          h->TRIM.flag.lsa_turn,
                          &h->tb_cb);

    } else {
        TableMgr_TRIM_LSA(h->TableMgr_handle,
                          left,
                          len,
                          h->TRIM.flag.lsa_turn,
                          &h->tb_cb);
    }
    h->TRIM.flag.lsa_turn++;

    return STATUS_OK;
}

s8 TRIM_CallTableL1_P(void *handle, LSA_union left, LSA_union right) {
    // This function will trim Partial L1
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u16 len;

    len = right.val - left.val + 1;
    h->TRIM.flag.tb_send_cnt++;
    TRIM_SetTableCBData(h, TRIM_CheckExit_table);
    if (h->hmb_en) {
        TableMgr_TRIM_LSA_HMB(h->TableMgr_handle,
                          left,
                          len,
                          h->TRIM.flag.lsa_turn,
                          &h->tb_cb);
    } else {
        TableMgr_TRIM_LSA(h->TableMgr_handle,
                          left,
                          len,
                          h->TRIM.flag.lsa_turn,
                          &h->tb_cb);
    }
    h->TRIM.flag.lsa_turn++;

    return STATUS_OK;
}

s8 TRIM_CallTableL1_F(void *handle, LSA_union left, LSA_union right) {
    // This function will trim Full L1
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u16 len;
    LSA_Short_union left_L1_idx, right_L1_idx;
    TRIM_LSATransShort(left, &left_L1_idx);
    TRIM_LSATransShort(right, &right_L1_idx);

    len = right_L1_idx.val - left_L1_idx.val + 1;
    h->TRIM.flag.tb_send_cnt++;
    TRIM_SetTableCBData(h, TRIM_CheckExit_table);
    if (h->hmb_en) {
        TableMgr_TRIM_L1_HMB(h->TableMgr_handle, left_L1_idx, len, \
                     h->TRIM.flag.L1_turn, &h->tb_cb);
    } else {
        TableMgr_TRIM_L1(h->TableMgr_handle, left_L1_idx, len, \
                     h->TRIM.flag.L1_turn, &h->tb_cb);
    }
    h->TRIM.flag.L1_turn++;
    return STATUS_OK;
}

s8 TRIM_CallTableL1_PFP(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_union temp_left, temp_right;

    // Front
    TRIM_CallTableL1_P(handle, h->TRIM.hand.left, \
                       h->TRIM.hand.L1_sub_left);

    // Middle
    temp_left.val = h->TRIM.hand.L1_sub_left.val + 1;
    temp_right.val = h->TRIM.hand.L1_sub_right.val - 1;
    TRIM_CallTableL1_F(handle, temp_left, temp_right);

    // Last
    TRIM_CallTableL1_P(handle, h->TRIM.hand.L1_sub_right, \
                       h->TRIM.hand.right);
    return STATUS_OK;
}

s8 TRIM_CallTableL1_FP(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_union temp_left, temp_right;

    // Front
    if (h->TRIM.L0_data.mode) {
        temp_left = h->TRIM.hand.L0_sub_right;
        temp_right = h->TRIM.hand.right;
        temp_right.lsa.L1_oft = START_OFT;
        temp_right.val -= 1;
    } else {
        temp_left = h->TRIM.hand.left;
        temp_right.val = h->TRIM.hand.L1_sub_right.val - 1;
    }
    TRIM_CallTableL1_F(handle, temp_left, temp_right);

    // Last
    if (h->TRIM.L0_data.mode) {
        temp_left = h->TRIM.hand.right;
        temp_left.lsa.L1_oft = START_OFT;
        temp_right = h->TRIM.hand.right;
    } else {
        temp_left = h->TRIM.hand.L1_sub_right;
        temp_right = h->TRIM.hand.right;
    }
    TRIM_CallTableL1_P(handle, temp_left, temp_right);

    return STATUS_OK;
}

s8 TRIM_CallTableL1_PF(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_union temp_left, temp_right;

    // Front
    if (h->TRIM.L0_data.mode) {
        temp_left = h->TRIM.hand.left;
        temp_right = h->TRIM.hand.left;
        temp_right.lsa.L1_oft = END_OFT;
    } else {
        temp_left = h->TRIM.hand.left;
        temp_right = h->TRIM.hand.L1_sub_left;
    }
    TRIM_CallTableL1_P(handle, temp_left, temp_right);

    // LAST
    if (h->TRIM.L0_data.mode) {
        temp_left = h->TRIM.hand.left;
        temp_left.lsa.L1_oft = END_OFT;
        temp_left.val += 1;
        temp_right = h->TRIM.hand.L0_sub_left;
    } else {
        temp_left.val = h->TRIM.hand.L1_sub_left.val + 1;
        temp_right = h->TRIM.hand.right;
    }
    TRIM_CallTableL1_F(handle, temp_left, temp_right);

    return STATUS_OK;
}

s8 TRIM_CallTableL1_PP(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // Front
    TRIM_CallTableL1_P(handle, h->TRIM.hand.left, h->TRIM.hand.L1_sub_left);

    // Last
    TRIM_CallTableL1_P(handle, h->TRIM.hand.L1_sub_right, h->TRIM.hand.right);

    return STATUS_OK;
}

s8 TRIM_CallL1TableEntry(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // According to range type to call TableMgr
    switch (h->TRIM.L1_type) {
        case L1_INIT: {
            D_ASSERT(0);
            break;
        }
        case L1_PFP: {
            TRIM_CallTableL1_PFP(handle);
            break;
        }
        case L1_FP: {
            TRIM_CallTableL1_FP(handle);
            break;
        }
        case L1_PF: {
            TRIM_CallTableL1_PF(handle);
            break;
        }
        case L1_PP: {
            TRIM_CallTableL1_PP(handle);
            break;
        }
    }
    return STATUS_OK;
}

s8 TRIM_SelectCrossL1Type(void *handle, LSA_union left, LSA_union right) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_Short_union left_L1_idx;
    LSA_Short_union right_L1_idx;
    TRIM_LSATransShort(left, &left_L1_idx);
    TRIM_LSATransShort(right, &right_L1_idx);

    // if range state is Cross_L1, then select range type, see doc
    if ((right_L1_idx.val - left_L1_idx.val > 1) &&
        ((left.lsa.L1_oft != 0) && (right.lsa.L1_oft != (LSA_PER_L1 - 1)))) {
        h->TRIM.L1_type = L1_PFP;
    } else if ((left.lsa.L1_oft ==0) && (right.lsa.L1_oft !=(LSA_PER_L1 - 1))) {
        h->TRIM.L1_type = L1_FP;
    } else if ((left.lsa.L1_oft !=0) && (right.lsa.L1_oft ==(LSA_PER_L1 - 1))) {
        h->TRIM.L1_type = L1_PF;
    } else if ((left.lsa.L1_oft !=0) && (right.lsa.L1_oft !=(LSA_PER_L1 - 1))) {
        h->TRIM.L1_type = L1_PP;
    } else {
        D_ASSERT(0);
    }
    return STATUS_OK;
}

s8 TRIM_SubSelectRangeState(void *handle, LSA_union left, LSA_union right) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_Short_union left_L1_idx;
    LSA_Short_union right_L1_idx;
    TRIM_LSATransShort(left, &left_L1_idx);
    TRIM_LSATransShort(right, &right_L1_idx);

    // Select range state by left and right subhand in handler, see doc
    if (left.lsa.L0_oft == 0 && right.lsa.L0_oft == (LSA_PER_L1 - 1) &&
        left.lsa.L1_oft == 0 && right.lsa.L1_oft == (LSA_PER_L1 - 1)) {
        h->TRIM.sub_range_state = TRIM_STATE_EXACT_L0;
    } else if (left.lsa.L1_oft == 0 && right.lsa.L1_oft == (LSA_PER_L1 - 1)) {
        h->TRIM.sub_range_state = TRIM_STATE_EXACT_L1;
    } else if (right_L1_idx.val - left_L1_idx.val >= 1) {
        h->TRIM.sub_range_state = TRIM_STATE_CROSS_L1;
    } else if ((right.val - left.val < LSA_PER_L1) &&
        (right_L1_idx.val == left_L1_idx.val)) {
        h->TRIM.sub_range_state = TRIM_STATE_CROSS_LSA;
    } else {
        D_ASSERT(0);
    }
    return STATUS_OK;
}

s8 TRIM_CallTableMgrCrossL0(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    TRIM_SetSubHand(h);
    h->TRIM.L0_data.mode = 1;

    /* Front */
    // Select front part's range state
    TRIM_SubSelectRangeState(handle, h->TRIM.hand.left, \
                             h->TRIM.hand.L0_sub_left);

    // According to range state to call TableMgr
    switch (h->TRIM.sub_range_state) {
        case TRIM_STATE_CROSS_INIT:
            D_ASSERT(0);
            break;
        case TRIM_STATE_EXACT_L0:

            h->TRIM.L0_data.start_idx = h->TRIM.hand.left.lsa.L0_idx;
            h->TRIM.L0_data.len++;
            break;
        case TRIM_STATE_EXACT_L1:
            TRIM_CallTableMgrExactL1(h, h->TRIM.hand.left, \
                                     h->TRIM.hand.L0_sub_left);
            break;
        case TRIM_STATE_CROSS_L0:
            D_ASSERT(0);
            break;
        case TRIM_STATE_CROSS_L1:
            TRIM_SelectCrossL1Type(h, h->TRIM.hand.left, \
                                   h->TRIM.hand.L0_sub_left);
            TRIM_CallL1TableEntry(h);
            break;
        case TRIM_STATE_CROSS_LSA:
            TRIM_CallTableMgrCrossLSA(h, h->TRIM.hand.left, \
                                      h->TRIM.hand.L0_sub_left);
            break;
    }

    /* Middle */
    u32 len = h->TRIM.hand.right.lsa.L0_idx - \
              h->TRIM.hand.left.lsa.L0_idx;
    if (len > 1) {
        len--;
        u32 temp_L0_idx = h->TRIM.hand.left.lsa.L0_idx + 1;

        if (h->TRIM.L0_data.start_idx == -1) {
            h->TRIM.L0_data.start_idx = temp_L0_idx;
        }
        h->TRIM.L0_data.len += len;
    }

    /* Last */
    // Select last part's range state
    TRIM_SubSelectRangeState(handle, h->TRIM.hand.L0_sub_right, \
                             h->TRIM.hand.right);

    // According to range state to call TableMgr
    switch (h->TRIM.sub_range_state) {
        case TRIM_STATE_CROSS_INIT: {
            D_ASSERT(0);
            break;
        }
        case TRIM_STATE_EXACT_L0:

            if (h->TRIM.L0_data.start_idx == -1) {
                h->TRIM.L0_data.start_idx = \
                    h->TRIM.hand.L0_sub_right.lsa.L0_idx;
            }
            h->TRIM.L0_data.len++;
            break;
        case TRIM_STATE_EXACT_L1:
            TRIM_CallTableMgrExactL1(h, h->TRIM.hand.L0_sub_right, \
                                     h->TRIM.hand.right);
            break;
        case TRIM_STATE_CROSS_L1:
            TRIM_SelectCrossL1Type(h, h->TRIM.hand.L0_sub_right, \
                                   h->TRIM.hand.right);
            TRIM_CallL1TableEntry(h);
            break;
        case TRIM_STATE_CROSS_LSA:
            TRIM_CallTableMgrCrossLSA(h, h->TRIM.hand.L0_sub_right, \
                                      h->TRIM.hand.right);
            break;
        case TRIM_STATE_CROSS_L0:
            D_ASSERT(0);
            break;
    }
    if (h->TRIM.L0_data.start_idx != -1) {
        TRIM_SetTableCBData(h, TRIM_CheckExit_table);
        h->TRIM.flag.tb_send_cnt++;
        u8 start = h->TRIM.L0_data.start_idx;
        u8 len_t = h->TRIM.L0_data.len;
        if (h->hmb_en) {
            TableMgr_TRIM_L0_HMB(h->TableMgr_handle, start, len_t, &h->tb_cb);
        } else {
            TableMgr_TRIM_L0(h->TableMgr_handle, start, len_t, &h->tb_cb);
        }
    }
    return STATUS_OK;
}

s8 TRIM_CutRangeAndCall(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // According to range state to call TableMgr
    switch (h->TRIM.range_state) {
        case TRIM_STATE_CROSS_INIT:
            D_ASSERT(0);
            break;
        case TRIM_STATE_CROSS_L0:
            TRIM_CallTableMgrCrossL0(h);
            break;
        case TRIM_STATE_CROSS_L1:
            TRIM_SelectCrossL1Type(handle, h->TRIM.hand.left, \
                                   h->TRIM.hand.right);
            TRIM_CallL1TableEntry(h);
            break;
        case TRIM_STATE_CROSS_LSA:
            TRIM_CallTableMgrCrossLSA(h, h->TRIM.hand.left, \
                                      h->TRIM.hand.right);
            break;
        case TRIM_STATE_EXACT_L0:
            TRIM_CallTableMgrExactL0(h, h->TRIM.hand.left, \
                                     h->TRIM.hand.right);
            break;
        case TRIM_STATE_EXACT_L1:
            TRIM_CallTableMgrExactL1(h, h->TRIM.hand.left, \
                                     h->TRIM.hand.right);
            break;
    }
    return STATUS_OK;
}

s8 TRIM_SelRangeState(void *handle, LSA_union left, LSA_union right) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    LSA_Short_union left_L1_idx;
    LSA_Short_union right_L1_idx;
    TRIM_LSATransShort(h->TRIM.hand.left, &left_L1_idx);
    TRIM_LSATransShort(h->TRIM.hand.right, &right_L1_idx);

    // Select range state by left and right hand in handler
    // See range state in doc
    if (left.lsa.L0_oft == 0 && right.lsa.L0_oft == (LSA_PER_L1 - 1) && \
        (left.lsa.L1_oft == 0 && right.lsa.L1_oft == (LSA_PER_L1 - 1))) {
        h->TRIM.range_state = TRIM_STATE_EXACT_L0;
    } else if ((left.lsa.L1_oft == 0 && right.lsa.L1_oft == (LSA_PER_L1 - 1)) &&
        ((right.lsa.L0_idx - left.lsa.L0_idx) == 0)) {
        h->TRIM.range_state = TRIM_STATE_EXACT_L1;
    } else if ((right.lsa.L0_idx - left.lsa.L0_idx) >= 1) {
        h->TRIM.range_state = TRIM_STATE_CROSS_L0;
    } else if ((right_L1_idx.val - left_L1_idx.val >= 1)) {
        h->TRIM.range_state = TRIM_STATE_CROSS_L1;
    } else if (((right.val - left.val) < LSA_PER_L1) &&
        (right.lsa.L0_oft == left.lsa.L0_oft)) {
        h->TRIM.range_state = TRIM_STATE_CROSS_LSA;
    } else {
        D_ASSERT(0);
    }
    return STATUS_OK;
}

s8 TRIM_CompareWBuffLSA(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // Check trim target lsa is in WBuff or not
    BuffMgr_CheckWBuffLSATRIM(h->BuffMgr_handle, h->TRIM.hand.left.val, \
                              h->TRIM.hand.right.val);

    if (h->hmb_en) {
        HMBMgr_CheckHMBLSATRIM(h->HMBMgr_handle, h->TRIM.hand.left.val, \
                               h->TRIM.hand.right.val);
    }

    // Check trim target lsa is recorded by RWMgr
    RWMgr_TrimLSAList(h, h->TRIM.hand.left.val, h->TRIM.hand.right.val);

    // Check trim target lsa is recorded by GC
    if (h->GCData_handle != NULL) {
        GCData_TrimLSAList(h->GCData_handle, h->TRIM.hand.left.val, \
                           h->TRIM.hand.right.val);
    }
    return STATUS_OK;
}

s8 TRIM_OverLapping(void *handle) {
    // This function will compare cur hand and next hand
    // If both are ovarlapping, update max length's left and right
    // Keep going to check next hand is overlapping or not
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u32 cur_left, cur_right, next_left, next_right;
#if TRIM_DEBUG_MSG
    debug_round++;
    if (debug_round_print) {
        printf("  [CNT] round %d\n", debug_round);
    }
#endif
    // Set left and right hand
    if (NVMe_check_lba_data_4K(h->NVMe_handle)) {
        cur_left = h->TRIM.hand.left.val;
        cur_right = h->TRIM.hand.right.val;
    } else {
        cur_left = h->TRIM.hand.left_512B;
        cur_right = h->TRIM.hand.right_512B;
    }

    // look up next hand, if cur_range is the end of ring buff, get base buff
    h->TRIM.cur_range += 1;
    if (h->TRIM.cur_range == \
        (((dataset_range_t *)h->TRIM.base_buff_addr) + TRIM_RANGE_NUM)) {
        h->TRIM.cur_range = (dataset_range_t *)h->TRIM.base_buff_addr;
    }

    // Minus one for each range checked
    h->TRIM.NV_list.range_cnt[h->TRIM.cur_cmd_idx]--;

    // If this round nvme still has rest ranges, get into while loop to check
    while (h->TRIM.NV_list.range_cnt[h->TRIM.cur_cmd_idx] > 0) {
        // Recoed next left and right hand
        const dataset_range_t *next_range = h->TRIM.cur_range;
        next_left = next_range->startLBA;
        next_right = next_range->startLBA + next_range->logicBlockLength - 1;

        // Overlapping check
        if (((next_left > cur_right) && (next_left - cur_right > 1)) ||
            ((cur_left > next_right) && (cur_left - next_right > 1))) {
            // No Overlapping
            break;
        } else {
            // Overlapping! choose smallest left and largest right
            cur_left = min(cur_left, next_left);
            cur_right = max(cur_right, next_right);

            // Check next range weather at the end of ring buffer
            h->TRIM.cur_range += 1;
            if (h->TRIM.cur_range == \
                (((dataset_range_t *)h->TRIM.base_buff_addr) + \
                    TRIM_RANGE_NUM)) {
                h->TRIM.cur_range = (dataset_range_t *)h->TRIM.base_buff_addr;
            }

            // Minus one for each range checked
            h->TRIM.NV_list.range_cnt[h->TRIM.cur_cmd_idx]--;
        }
    }

    // Finish overlapping check, store hand information in handler
    if (NVMe_check_lba_data_4K(h->NVMe_handle)) {
        h->TRIM.hand.left.val = cur_left;
        h->TRIM.hand.right.val = cur_right;
    } else {
        h->TRIM.hand.left_512B = cur_left;
        h->TRIM.hand.right_512B = cur_right;
    }
#if TRIM_DEBUG_MSG
    if (debug_hand_print) {
        printf("  [hand]  left %d , right %d , base %llx , cur %llx\n",
               cur_left, cur_right, h->TRIM.base_buff_addr, \
               (h->TRIM.cur_range-1));
    }
    if (debug_round >= SPEC_ROUND && (cur_left <= debug_lba && debug_lba <= cur_right)) {
        printf("  [hand]  left %d , right %d , base %llx , cur %llx ,round %d\n",
               cur_left, cur_right, h->TRIM.base_buff_addr, \
               (h->TRIM.cur_range-1) , debug_round);
        printf("  [hand]  left L0_idx %d , L0_oft %d , L1_oft %d\n", \
               h->TRIM.hand.left.lsa.L0_idx, \
               h->TRIM.hand.left.lsa.L0_oft, \
               h->TRIM.hand.left.lsa.L1_oft);
        printf("  [hand] right L0_idx %d , L0_oft %d , L1_oft %d\n", \
               h->TRIM.hand.right.lsa.L0_idx, \
               h->TRIM.hand.right.lsa.L0_oft, \
               h->TRIM.hand.right.lsa.L1_oft);
        LSA_union issue_lsa;
        issue_lsa.val = debug_lba;
        printf("  [hand] issue L0_idx %d , L0_oft %d , L1_oft %d , %x , %d \n", \
                   issue_lsa.lsa.L0_idx, \
                   issue_lsa.lsa.L0_oft, \
                   issue_lsa.lsa.L1_oft, \
                   issue_lsa.val, \
                   issue_lsa.val);
    }
#endif
    return STATUS_OK;
}

s8 TRIM_InitVar(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // Initialize L0 data structure
    h->TRIM.L0_data.mode = 0;
    h->TRIM.L0_data.start_idx = -1;
    h->TRIM.L0_data.len = 0;

    // Initialize state
    h->TRIM.state = TRIM_GOING;
    h->TRIM.L1_type = L1_INIT;
    h->TRIM.type_512B = INIT_512B;
    h->TRIM.range_state = TRIM_STATE_CROSS_INIT;

    // Initialize flag
    h->TRIM.flag.tbdone = FALSE;
    h->TRIM.flag.tb_send_cnt = 0;
    h->TRIM.flag.tb_done_cnt = 0;
    h->TRIM.flag.rw_send_cnt = 0;
    h->TRIM.flag.rw_done_cnt = 0;
    h->TRIM.flag.lsa_turn = 0;
    h->TRIM.flag.L1_turn = 0;

    // Initialize left, right hand
    if (NVMe_check_lba_data_4K(h->NVMe_handle)) {
        h->TRIM.hand.left.val = h->TRIM.cur_range->startLBA;
        h->TRIM.hand.right.val = h->TRIM.cur_range->startLBA + \
            h->TRIM.cur_range->logicBlockLength - 1;
    } else {
        h->TRIM.hand.left_512B = h->TRIM.cur_range->startLBA;
        h->TRIM.hand.right_512B = h->TRIM.cur_range->startLBA + \
            h->TRIM.cur_range->logicBlockLength - 1;
    }
    return STATUS_OK;
}

s8 TRIM_UpdateVar(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    u16 cur_idx = h->TRIM.cur_cmd_idx;

    // Those variable should minus when we finish this round nvme cmd
    h->TRIM.get_nvme_cnt--;
    h->TRIM.Buff_alloc_cnt -= h->TRIM.NV_list.NR[cur_idx];

    // Update buff ptr
    h->TRIM.buff_tail = (h->TRIM.buff_tail + \
        h->TRIM.NV_list.NR[cur_idx]) % TRIM_RANGE_NUM;

    // Update NV_list data structure's index
    h->TRIM.cur_cmd_idx = (h->TRIM.cur_cmd_idx + 1) % NVME_TRIM_MAX_NUM;
    return STATUS_OK;
}

s8 TRIM_Exit(void *handle) {
    // This is TableMgr call back function
    // First in this function, we need to check this round nvmd cmd still have
    // rest range or not, if yes, goto #1, keep Analyzing range, if not, goto #2
    // then check weather Buff have another rest nvme cmd, if yes, goto #3,
    // otherwise, goto #4
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // if this round nvme cmd is done, get into and call TableMgr_done API,
    // then watting to call back TRIM_Exit
    if ((h->TRIM.flag.tbdone == FALSE) && \
        ((h->TRIM.NV_list.range_cnt[h->TRIM.cur_cmd_idx] == 0))) {
        TRIM_CallTable_Done(handle);
        h->TRIM.flag.tbdone = TRUE;
        return STATUS_OK;
    }

    // After TableMgr_done API call back, mean this round nvme cmd finish
    // Check buff still have another nvme cmd or not
    if (h->TRIM.NV_list.range_cnt[h->TRIM.cur_cmd_idx] == 0) {
        /* In future , we need return h->TRIM.NV_list.ID[h->TRIM.cur_cmd_idx];*/
        // Make rw_fifo forward
        SetHeadProceed(handle);
        // #2
        // Finish this round nvme cmd, update variable about cnt, ptr, idx
        TRIM_UpdateVar(handle);

        if (h->TRIM.get_nvme_cnt == 0) {
            // #4
            // Call RWCmdProc, trim finished!
#if (CONFIG_BUILD_MODE == BUILD_MODE_MP)
            NLOG(F_TRIM, MAINCORE0_C, 0, "[c0] [TRIM] Finish TRIM flow");
#endif            
            RWMgr_RWCmdProc(h);
            return STATUS_OK;
        } else {
            // #3
            dataset_range_t*base = (dataset_range_t*)h->TRIM.base_buff_addr;
            u16 cur_idx = h->TRIM.cur_cmd_idx;
            u16 offset = h->TRIM.NV_list.start[cur_idx] % TRIM_RANGE_NUM;

            // Prepare to analyze next nvme cmd
            TRIM_AnalyzeRange_init(handle, (env_addr_t *)(base + offset));
            TRIM_AnalyzeRange(handle);
            return STATUS_OK;
        }
    } else {
        // #1
        TRIM_AnalyzeRange(handle);
        return STATUS_OK;
    }
}

s8 TRIM_CheckExit_rw(void *handle) {
    // This is RWMgr call back function
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // If every RWMgr API done, get into TRIM_Exit
    if (!((h->TRIM.hand.left_512B_idx == FIRST_512B_INDEX) &&
        (h->TRIM.hand.right_512B_idx == LAST_512B_INDEX))) {
        h->TRIM.flag.rw_done_cnt++;
    }

    if (h->TRIM.flag.rw_done_cnt == h->TRIM.flag.rw_send_cnt) {
        TRIM_Exit(handle);
        return STATUS_OK;
    }
    return STATUS_OK;
}

s8 TRIM_CheckExit_table(void *handle) {
    // This is TableMgr call back function
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // If every TableMgr API done, get into TRIM_Exit
    h->TRIM.flag.tb_done_cnt++;

    if (NVMe_check_lba_data_4K(h->NVMe_handle)) {
        if (h->TRIM.flag.tb_done_cnt == h->TRIM.flag.tb_send_cnt) {
            TRIM_Exit(handle);
            return STATUS_OK;
        }
    } else {
        if (h->TRIM.flag.tb_done_cnt == h->TRIM.flag.tb_send_cnt) {
            TRIM_CallRW512B_RMW(handle);
            return STATUS_OK;
        }
    }
    return STATUS_OK;
}

s8 TRIM_AnalyzeRange(void *handle) {
    // this is trim main function, it will keep looping
    // until all the ranges in this nvme command have been processed.
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;

    // Initial variables, include state, flag, left hand, right hand
    TRIM_InitVar(handle);

    // Use greedy algo to check next range and cur range is overlapping or not
    TRIM_OverLapping(handle);

    // Set subhand for SelRangeState and CutTangeAndCall, see subhand in doc
    if (NVMe_check_lba_data_4K(h->NVMe_handle)) {
        TRIM_SetSubHand(handle);
    } else {
        // In 512B, Call RWMgr in this function, see subhand_512B in doc
        TRIM_SetSubHand_512B(handle);
    }

    // In 512B if type is P, PP, We do not need to call TableMgr
    if (NVMe_check_lba_data_512B(h->NVMe_handle)) {
        if ((h->TRIM.type_512B == P_512B) || (h->TRIM.type_512B == PP_512B)) {
            TRIM_CallRW512B_RMW(handle);
            return STATUS_OK;
        }
    }

    // Check trim target is in WBuff or not, then check RWMgr and GC
    TRIM_CompareWBuffLSA(handle);

    // Select Range state by left and right hand
    TRIM_SelRangeState(handle, h->TRIM.hand.left, h->TRIM.hand.right);

    // According to Range state, call TableMgr to trim target LSA, L1, L0
    TRIM_CutRangeAndCall(handle);

    return STATUS_OK;
}

s8 TRIM_AnalyzeRange_init(void *handle, env_addr_t *start_range) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
    // initialize variables
    memset(&h->TRIM.hand, 0x00, sizeof(h->TRIM.hand));

    // get first range data structure, store in handle.
    h->TRIM.cur_range = (dataset_range_t *)start_range;
#if TRIM_DEBUG_MSG
    if (debug_getnvme_print) {
        printf("  [ADDR] AnalyzeRange init cur_range %lx\n", start_range);
    }
#endif
    return STATUS_OK;
}

void TRIM_GetNVME(RWMgr_handle_t *h) {
    u16 fifo_idx, i = 0;
    const RWCmd_fifo_ctrl_t *rw_ctrl = &h->rw_ctrl;
    RWCmd_fifo_t *rw_fifo = &h->rw_fifo[0], *cur_fifo_entry = NULL;

    // Get nvme cmd, do while loop will get multi nvme cmd until buff full
    do {
        // cur_fifo_entry will get current rw_fifo entry(trim cmd)
        cur_fifo_entry = &rw_fifo[(rw_ctrl->head + i) % RW_FIFO_DEPTH];
#if TRIM_DEBUG_MSG
    debug_nv_cnt++;
    RWCmd_fifo_t *temp_fifo = &h->rw_fifo[0];
    if (debug_fifo_print) {
        for (u16 i = 0; i < rw_ctrl->cnt; i++) {
            printf("cmd type %d\n", \
                   temp_fifo[(rw_ctrl->head + i) % RW_FIFO_DEPTH].cmd_type);
        }
    }
#endif

        // Get how many range count in this round nvme cmd
        h->TRIM.cmd_num_range = cur_fifo_entry->len + 1;  // NR is 0's based

        // if buff do not have enough space, stop to get next nvme
        if ((h->TRIM.Buff_alloc_cnt + h->TRIM.cmd_num_range < TRIM_RANGE_NUM) &&
            (h->TRIM.get_nvme_cnt < NVME_TRIM_MAX_NUM)) {
            // Record this round cmd info
            if (h->TRIM.NV_list.range_cnt[h->TRIM.cmd_idx] != 0) {
                D_ASSERT(0);
            }
            h->TRIM.NV_list.ID[h->TRIM.cmd_idx] = cur_fifo_entry->ctag;
            h->TRIM.NV_list.NR[h->TRIM.cmd_idx] = h->TRIM.cmd_num_range;
            h->TRIM.NV_list.range_cnt[h->TRIM.cmd_idx] = h->TRIM.cmd_num_range;
            h->TRIM.NV_list.start[h->TRIM.cmd_idx] = \
                (h->TRIM.buff_front + 1) % TRIM_RANGE_NUM;

            // Record get how many nvme cnt and TBuff allocated cnt
            h->TRIM.get_nvme_cnt++;
            h->TRIM.Buff_alloc_cnt += h->TRIM.cmd_num_range;

            // Let NV_list array index proceed, preparing for next cmd
            h->TRIM.cmd_idx = (h->TRIM.cmd_idx + 1) % NVME_TRIM_MAX_NUM;

            // Get TRIM base buff addr, set front proceed , get cur_buff_addr
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
            BuffMgr_GetTRIMBuffAddr(h->BuffMgr_handle, &h->TRIM.base_buff_addr);
#elif (CONFIG_BUILD_MODE == BUILD_MODE_MP)
            h->TRIM.base_buff_addr = (env_addr_t *)BuffMgr_GetTRIMBuffAddr;
#endif
            dataset_range_t *base = (dataset_range_t *)h->TRIM.base_buff_addr;
            // memcpy Range to Buff
            u16 front = h->TRIM.buff_front;
            u16 cur_NR = h->TRIM.NV_list.NR[h->TRIM.chase_cmd_idx];
            if (front + cur_NR > TRIM_RANGE_NUM - 1) {
                // Part of Ranges are placed in back of Buff,rest in the front
                /* Part of Range front */
                u16 len = (TRIM_RANGE_NUM - 1) - front;
                h->TRIM.cur_buff_addr = base + ((front + 1) % TRIM_RANGE_NUM);
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                memcpy((env_addr_t *)h->TRIM.cur_buff_addr, \
                       (env_addr_t *)(intptr_t)cur_fifo_entry->prp, \
                       (len)* sizeof(dataset_range_t));
#endif
#if TRIM_DEBUG_MSG
    if (debug_buff_print) {
        printf("  [BUFF] base_buff_addr %lx\n", h->TRIM.base_buff_addr);
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
        printf("  [BUFF] cur_buff_addr %lx , cur_fifo_entry->prp %lx , " \
                                         "len %u , buff_start %u, cut\n", \
                       h->TRIM.cur_buff_addr, cur_fifo_entry->prp, \
                       len, ((front + 1) % TRIM_RANGE_NUM));
#endif
    }
    if (debug_getnvme_print) {
        printf("  [NVLIST] NR %d , nvme_num %d\n", \
                h->TRIM.NV_list.NR[h->TRIM.chase_cmd_idx], debug_nv_cnt);
        dataset_range_t *temp_ptr = (dataset_range_t *)h->TRIM.cur_buff_addr;
        for (u16 i = 0; i < len; i++) {
            printf("  [NVLIST] start %lu   %lx , len %u\n", \
                   temp_ptr->startLBA, \
                   temp_ptr->startLBA, \
                   temp_ptr->logicBlockLength);
            temp_ptr+=1;
        }
    }
#endif

                /* Part of Range last */
                u16 last_len = h->TRIM.cmd_num_range - len;
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                const dataset_range_t *last_src_addr = \
                    (dataset_range_t *)(intptr_t)cur_fifo_entry->prp + len;
                memcpy((env_addr_t *)h->TRIM.base_buff_addr,
                       (env_addr_t *)last_src_addr,
                       (last_len)* sizeof(dataset_range_t));
#endif
                h->TRIM.buff_front = last_len - 1;

#if TRIM_DEBUG_MSG
    if (debug_buff_print) {
        printf("  [BUFF] cur_buff_addr %lx , len %d , front %d, cut\n",
               h->TRIM.base_buff_addr, last_len, front);
    }
    if (debug_buff_print) {
        dataset_range_t *temp_ptr = (dataset_range_t *)h->TRIM.base_buff_addr;
        for (u16 i = 0; i < last_len; i++) {
            printf("  [NVLIST] start %lu   %lx , len %u\n", \
                   temp_ptr->startLBA, \
                   temp_ptr->startLBA, \
                   temp_ptr->logicBlockLength);
            temp_ptr+=1;
        }
    }
#endif

            } else {
                // Ranges are put in Buffer successively
                h->TRIM.cur_buff_addr = base + (front + 1);
                h->TRIM.buff_front = (front + cur_NR) % TRIM_RANGE_NUM;
#if (CONFIG_BUILD_MODE == BUILD_MODE_SIM)
                memcpy((env_addr_t *)h->TRIM.cur_buff_addr,
                       (env_addr_t *)(intptr_t)cur_fifo_entry->prp,
                       (cur_fifo_entry->len + 1)* sizeof(dataset_range_t));
#endif
#if TRIM_DEBUG_MSG
    if (debug_buff_print) {
        printf("  [BUFF] cur_buff_addr %lx , len %d , front %d, single\n", \
                   h->TRIM.cur_buff_addr, \
                   cur_fifo_entry->len + 1, \
                   (h->TRIM.buff_front));
    }
    if (debug_getnvme_print) {
        printf("  [NVLIST] NR %d , nvme_num %d\n", \
               h->TRIM.NV_list.NR[h->TRIM.chase_cmd_idx], debug_nv_cnt);
        dataset_range_t *temp_ptr = (base +  \
                        h->TRIM.NV_list.start[h->TRIM.chase_cmd_idx]);
        for (u16 i = 0; i < (cur_fifo_entry->len + 1); i++) {
            printf("  [NVLIST] start %lu   %lx , len %u\n", \
                   temp_ptr->startLBA, \
                   temp_ptr->startLBA, \
                   temp_ptr->logicBlockLength);
            temp_ptr+=1;
        }
    }
#endif
            }
            // Update chase idx,preparing to get next nvme and store in NV_list
            h->TRIM.chase_cmd_idx = \
                (h->TRIM.chase_cmd_idx + 1) % NVME_TRIM_MAX_NUM;
            // i used to proceed rw_fifo entry, check next nvme is trim or not
            i++;
            fifo_idx = (rw_ctrl->head + i) % RW_FIFO_DEPTH;
#if TRIM_DEBUG_MSG
      if (debug_bufflist_print) {
          for (u16 i = 0; i < TRIM_RANGE_NUM; i++) {
              dataset_range_t *temp_addr = base + i;
              printf("  [BuffList] buff_idx %d , budd_addr %lx , " \
                      "start %u %x , len %lu\n", \
                     i, \
                     temp_addr, \
                     temp_addr->startLBA, \
                     temp_addr->startLBA, \
                     temp_addr->logicBlockLength);
          }
          printf("  *-----------------------------------------------------*\n");
      }
#endif
        } else {
            // if Buff do not have enough space, exit do while loop
            break;
        }
    }while((rw_fifo[fifo_idx].valid) && \
        (rw_fifo[fifo_idx].cmd_type == NVM_CMD_DATASET_MGMNT) && \
        (i <rw_ctrl->cnt -1));  // if next nvme is not trim, exit do while loop
}

void RWMgr_TrimProc(void *handle) {
    RWMgr_handle_t *h = (RWMgr_handle_t *)handle;
#if (CONFIG_BUILD_MODE == BUILD_MODE_MP)
    NLOG(F_TRIM, MAINCORE0_C, 0, "[c0] [TRIM] Start TRIM flow");
#endif
#if TRIM_DEBUG_MSG
    if (debug_in_out_print) {
        printf("  [HEAD]Trim enter!\n");
    }
#endif
    TRIM_GetNVME(h);
    TRIM_AnalyzeRange_init(handle, \
                           (env_addr_t *)(((dataset_range_t*)h->TRIM.base_buff_addr) + \
                               h->TRIM.NV_list.start[h->TRIM.cur_cmd_idx]));
    TRIM_AnalyzeRange(handle);
}

#if (CONFIG_BUILD_MODE == BUILD_MODE_MP)
    #pragma default_function_attributes =
#endif

