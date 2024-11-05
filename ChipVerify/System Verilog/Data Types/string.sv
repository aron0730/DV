// String
module tb;
    // Declare a string variable called "dialog" to store string literals
    // Initialize the variable to "Hello!"

    string dialog = "Hello!";

    initial begin
        // Display the string using %s string format
        $display("%s", dialog);

        // Iterate through the string variable to identify individual characters and print
        foreach(dialog[i]) begin
            $display("%s", dialog[i]);
        end
    end
endmodule

/*
Hello!
H
e
l
l
o
!
*/

// A single ASCII character requires 8-bits (1 byte) and to store a string we would need 
// as many bytes as there are number of characters in the string.
reg [16*8-1:0] my_string;       // Can store 16 characters

my_string = "How are you";          // 5 zeros are padded from MSB, and 11 char are stored
my_string = "How are you doing?";   // 19 characters; my_string will get "w are you doing?"


module tb;
  string firstname = "Joey";
  string lastname  = "Tribbiani";

  initial begin
    // String Equality : Check if firstname equals or not equals lastname
    if (firstname == lastname)
      $display ("firstname=%s is EQUAL to lastname=%s", firstname, lastname);

    if (firstname != lastname)
      $display ("firstname=%s is NOT EQUAL to lastname=%s", firstname, lastname);

    // String comparison : Check if length of firstname < length of lastname
    if (firstname < lastname)
      $display ("firstname=%s is LESS THAN lastname=%s", firstname, lastname);

    // String comparison : Check if length of firstname > length of lastname
    if (firstname > lastname)
      $display ("firstname=%s is GREATER THAN lastname=%s", firstname, lastname);

    // String concatenation : Join first and last names into a single string
    $display ("Full Name = %s", {firstname, " ", lastname});

    // String Replication
    $display ("%s", {3{firstname}});

    // String Indexing : Get the ASCII character at index number 2 of both first and last names
    $display ("firstname[2]=%s lastname[2]=%s", firstname[2], lastname[2]);

  end
endmodule
/*
firstname=Joey is NOT EQUAL to lastname=Tribbiani
firstname=Joey is LESS THAN lastname=Tribbiani
Full Name = Joey Tribbiani
JoeyJoeyJoey
firstname[2]=e lastname[2]=i
*/

/*
str.len()

  用途：返回字串的長度（字元數量）。
  示例：int length = str.len();

str.putc()

  用途：將字串中的第 i 個位置的字元替換為指定的字元 c。
  參數：i 是要替換的字元位置，c 是新字元。
  示例：str.putc(3, "A"); // 將字串的第 4 個字元替換為 'A'

str.getc()

  用途：返回字串中第 i 個字元的 ASCII 碼。
  參數：i 是字元的位置。
  示例：byte ascii_value = str.getc(2); // 取得第 3 個字元的 ASCII 碼

str.tolower()

  用途：將字串中所有字母轉為小寫，並返回新的字串。
  示例：string lower_str = str.tolower();

str.compare()

  用途：將 str 與另一個字串 s 進行比較，模仿 C 語言中的 strcmp 函數。
  返回值：比較結果，0 表示相等，負數表示 str 小於 s，正數表示 str 大於 s。
  示例：int result = str.compare("Hello");


str.icompare()

  用途：不區分大小寫地將 str 與另一個字串 s 進行比較，模仿 C 語言中的 strcasecmp 函數。
  返回值：比較結果，0 表示相等，負數表示 str 小於 s，正數表示 str 大於 s。
  示例：int result = str.icompare("hello");


str.substr(i, j)

  用途：返回字串從位置 i 到位置 j 的子字串。
  參數：i 和 j 是子字串的起始和結束位置。
  示例：string sub = str.substr(2, 5); // 取得第 3 到第 6 個字元組成的子字串
*/

module tb;
  string str = "Hello World!";

  initial begin
    string tmp;

    // Print length of string "str"
    $display("str.len() = %0d", str.len());

    // Assign to tmp variable and put char "d" at index 3
    tmp = str;
    tmp.putc(3, "d");
    $display("str.putc(3, d) = %s", tmp);

    // Get the character at index 2
    $display("str.getc(2) = %s (%0d)", str.getc(2), str.getc(2));

    // Convert all characters to lower case
    $display("str.tolower() = %s", str.tolower());

    // Comparison
    tmp = "Hello World!";
    $display ("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));
    tmp = "How are you ?";
    $display ("[tmp,str are diff] str.compare(tmp) = %0d", str.compare(tmp));

    // Ignore case comparison
    tmp = "hello world!";
    $display ("[tmp is in lowercase] str.compare(tmp) = %0d", str.compare(tmp));
    tmp = "Hello World!";
    $display ("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));

    // Extract new string from i to j
    $display("str.substr(4,8) = %s", str.substr(4,8));

  end
endmodule