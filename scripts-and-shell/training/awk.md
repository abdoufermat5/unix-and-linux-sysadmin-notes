# AWK 

The awk command was named using the initials of the three people who wrote the original version in 1977: Alfred Aho, Peter Weinberger, and Brian Kernighan.

The awk command is a powerful programming language that allows easy manipulation of structured data and the generation of formatted reports. It is a standard feature of most Unix-like operating systems.

## Basic Usage

**awk** is used to filter and manipulate output from other programs and functions. awk works on programs that contain rules comprised of patterns and actions. The action awk takes is executed on the text that matches the pattern. Patterns are enclosed in curly braces ({}). Together, a pattern and an action form a rule. The entire awk program is enclosed in single quotes (').

For example, the following command prints the first column of the file `file.txt`:

```bash
awk '{print $1}' file.txt
```

The `$1` is a variable that represents the first column of the input. The `print` command prints the value of the variable.

There a couple of special field identifiers that can be used in awk:

- `$0` represents the entire line
- `$1` represents the first field
- `$2` represents the second field
- `$3` represents the third field
- `$NF` represents the last field

We can use the OFS (Output Field Separator) variable to change the output field separator. For example, to print the first and second columns of a file separated by a comma:

```bash
awk 'OFS="," {print $1, $2}' file.txt
```

There's also the BEGIN and END patterns that can be used to execute actions before and after processing the input. For example, the following command prints the number of lines in the file `file.txt`:

```bash
awk 'END {print NR}' file.txt
```

## Patterns

Patterns are used to match lines of input. If a pattern is not specified, the action is executed on every line of input. Patterns can be regular expressions, relational expressions, or any combination of the two.

For example, the following command prints the lines of the /etc/passwd file where user names start with the letter `a`:

```bash
awk -F: '/^a/ {print $1}' /etc/passwd
```

The `-F` option is used to specify the field separator. In this case, the field separator is `:`.

## Functions

awk has a number of built-in functions that can be used to manipulate data. For example, the `length` function returns the length of a string. The following command prints the length of the first field of the file `file.txt`:

```bash
awk '{print length($1)}' file.txt
```

The `tolower` and `toupper` functions can be used to convert strings to lowercase and uppercase, respectively. The following command prints the first field of the file `file.txt` in lowercase:

```bash
awk '{print tolower($1)}' file.txt
```

The `split` function can be used to split a string into an array. The following command splits the first field of the file `file.txt` into an array and prints the first element of the array:

```bash
awk '{split($1, a, "/"); print a[1]}' file.txt
```

## Write your own scripts

If your command line gets complicated, or you develop a routine you know you'll want to use again, you can transfer your awk command into a script.

As example we're going to do all of the following:

- Tell the shell which executable to use to run the script.
- Prepare awk to use the FS field separator variable to read input text with fields separated by colons (:).
- Use the OFS output field separator to tell awk to use colons (:) to separate fields in the output.
- Set a counter to 0 (zero).
- Set the second field of each line of text to a blank value (it's always an "x," so we don't need to see it).
- Print the line with the modified second field.
- Increment the counter.
- Print the value of the counter.

```bash
#!/usr/bin/awk -f 

BEGIN {
    # set the input and output field separators
    FS=":"
    OFS=":"
    # zero the accounts counter
    accounts=0
}
{
    # set field 2 to nothing
    $2=""
    # print the entire line 
    print $0
    # increment the accounts counter
    accounts++
}

END {
    # print the results
    print accounts " accounts.\n"
}
```