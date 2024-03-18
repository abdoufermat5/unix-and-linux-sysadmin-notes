# Chapter 7: Scripting and Shell

![Shell Scripting](https://cdn-learn.adafruit.com/guides/cropped_images/000/000/938/medium640/pngn_typing.png?1520625285)

## Scripting philosophy

### Write microscripts

Most admins keep a selection of short scripts for personal use (aka scriptlets) in their **~/bin** directories. Use these quickk-and-dirty scripts to address the pain points of your daily work.

For shell scripts, you also have the option of defining functions that live inside your shell configuration files (e.g., **.bash_profile** or **.bashrc**) rather than in freestanding script files. 

### Learn a few tools well

You can't be expert at everything, so become skilled at skimmin documentation and learning the basics of a new tool quickly.
**Laziness is a virtue**.

YOU SHOULD KNOW A SHELL, A TEXT EDITOR, AND A SCRIPTING LANGUAGE THOROUGHLY.

**NOT TO SPOIL, BUT THESE SHOULD BE BASH, VIM, AND PYTHON.**

Read the manuals from front to back, then regularly read books and blogs. There's no substitute for experience, but you can learn a lot from the experience of others.

### Pick the right scripting language

For a long time, the standard language for administrative scripts was the one defined by the **sh** shell. Shell scripts are typically used for light tasks such as automating a sequence of commands or assembling several filters to process data.

The shell is always available, so shell scripts are relatively portable and have few dependencies other than the commands they invoke. Whether or not you choose the shell, the shell might choose you: most environments include a hefty complement of existing sh scripts, and administrators frequently need to read, understand, and tweak those scripts.

As a programming language, **sh** is somewhat inelegant and limited. The syntax is idiosyncratic, and the shell lacks the advanced text processing features of modern languages--features that are often essential for administrative tasks.

**Perl** was the first language to challenge the shell's dominance. Perl is a powerful language with a rich set of features for text processing and system administration. It's also a general-purpose language, so it's useful for a wide range of tasks. Perl permits/encourages a certain **get it done and damn the torpedoes** style of coding, which can be a good or bad thing depending on your perspective.

These days, Perl is known as Perl 5 to distinguish it from Perl 6, which has finally reached general release after 15 years of gestation (woow!!). Unfortunately, Perl 5 is showing its age in comparison sith newer languages, and Perl 6 has yet to gain widespread adoption. A good suggestion might be to avoid Perl for new work.

If you come from the web development world, you might be tempted to apply your existing PHPH or Javascript skills to system administration. DON'T!!
Code is code but living in the same ecosystem as other sysadmins brings a variety of long-term benefits. **At the very least, avoiding PHP means you won't have to endure the ridicule of your local sysadmin Meetup**

Python and Ruby are modern, general-purpose programming languages that are both well suited for administrative work. These languages incorporate a couple of decades’ worth of language design advancements relative to the shell, and their text processing facilities are so powerful that **sh** can only weep and cower in shame.

### Follow best practices

- When run with inappropriate arguments, scripts should print a usage message and exit. For extra credit, implement a **--help** option that prints a more detailed message.
- Validate inputs and sanity-check derived values.
- Return a meaningful exit code: *zero* for success, *nonzero* for failure.
- Use appropriate naming conventions for variables, scripts, and routines.
- Assign meaningful names to variables that reflect their purpose.
- Start every script with a comment block that includes the script's name, purpose, author, and date of creation.
- Use a consistent coding style.
- Don't clutter your scripts with useless comments; assume intelligence and language fluency on the part of your readers.
- It's OK to run scripts as root, but avoid making them setuid root. Use sudo instead.
- Don't script what you don't understand. 
- With **bash**, use **-x** to echo commands before they are executed, and **-n** to check syntax
- Remember in Python, you are in debug mode unless you explicitly turn it off with a **-O** argument on the command line.

Tom Christiansen's five golden rules:

- Error messages should go to STDERR, not STDOUT.
- Include the name of the program that’s issuing the error.
- State what function or operation failed.
- If a system call fails, include the perror string.
- Exit with some code other than 0

## Shell Basics

A shell is a command-line interpreter that provides a user interface for the operating system. It interprets the commands that the user types and arranges for them to be carried out. The shell is so called because it is the outer layer of the operating system, the interface between the user and the kernel.

UNIX has always offered users a choice of shells, but some version of the Bourne shell, **sh**, has been standard on every UNIX and Linux system. The code for the original Bourne shell never made it out of AT&T licensing limbo, so these days sh is most commonly manifested in the form of the Almquist shell (known as **ash**, **dash**, or simply **sh**) or the “Bourne-again” shell, **bash**.

The Almquist shell is a reimplementation of the original Bourne shell without extra frills. By modern standards, it’s barely usable as a login shell. It exists only to run **sh** scripts efficiently.

**bash** focuses on interactive usability. Over the years, it has absorbed most of the useful features pioneered by other shells.

### Command line editing mode

**bash** has two command-line editing modes. By default, it uses **emacs** mode, but you can switch to **vi** mode by running **set -o vi**.

In **emacs** mode, you can use the following key combinations:

- **Ctrl-A**: Move to the beginning of the line.
- **Ctrl-E**: Move to the end of the line.
- **Ctrl-U**: Delete from the cursor to the beginning of the line.
- **Ctrl-K**: Delete from the cursor to the end of the line.
- **Ctrl-W**: Delete from the cursor to the start of the word.
- **Ctrl-Y**: Paste the last deleted text.
- **Ctrl-L**: Clear the screen.
- **Ctrl-R**: Search the history backwards.
- **Ctrl-S**: Search the history forwards.
- **Ctrl-C**: Cancel the command.
- **Ctrl-D**: Log out of the current session.
- **Ctrl-Z**: Suspend the current command.
- **Ctrl-Alt-T**: Open a new terminal window.
- **Ctrl-Alt-L**: Lock the screen.
- **Ctrl-Alt-Delete**: Log out.

In **vi** mode, you can use the following key combinations:

- **h**: Move the cursor left.
- **j**: Move the cursor down.
- **k**: Move the cursor up.
- **l**: Move the cursor right.
- **w**: Move the cursor to the start of the next word.
- **b**: Move the cursor to the start of the previous word.
- **0**: Move the cursor to the start of the line.
- **$**: Move the cursor to the end of the line.
- **x**: Delete the character under the cursor.
- **dd**: Delete the current line.
- **u**: Undo the last change.
- **Ctrl-R**: Redo the last change.
- **i**: Switch to insert mode.
- **A**: Append text to the end of the line.
- **R**: Overwrite text starting at the cursor.
- **Esc**: Switch to command mode.
- **v**: Switch to visual mode.

### Pipes and redirection

Every process has three communication channels: **stdin**, **stdout**, and **stderr**. Each of these channels is represented by a file descriptor: **0** for **stdin**, **1** for **stdout**, and **2** for **stderr**.

When you run a command, **stdin** is connected to the keyboard, and **stdout** and **stderr** are connected to the terminal. You can redirect these channels to files or other commands using the following operators:

- **>**: Redirect **stdout** to a file, overwriting the file if it exists.
For example, **ls > file.txt** writes the output of **ls** to **file.txt**.
- **>>**: Redirect **stdout** to a file, appending to the file if it exists.
For example, **ls >> file.txt** appends the output of **ls** to **file.txt**.
- **<**: Redirect **stdin** from a file.
For example, **cat < file.txt** reads the contents of **file.txt** and writes them to **stdout**.
- **2>**: Redirect **stderr** to a file, overwriting the file if it exists.
For example, **apt update 2> file.txt** writes the error output of **apt update** to **file.txt**.
- **2>>**: Redirect **stderr** to a file, appending to the file if it exists.
For example, **apt update 2>> file.txt** appends the error output of **apt update** to **file.txt**.
- **&>**: Redirect **stdout** and **stderr** to a file, overwriting the file if it exists.
For example, **apt update &> file.txt** writes the output of **apt update** to **file.txt**.
- **&>>**: Redirect **stdout** and **stderr** to a file, appending to the file if it exists.
For example, **apt update &>> file.txt** appends the output of **apt update** to **file.txt**.
- **|**: Connect **stdout** of one command to **stdin** of another command.
For example, **ls | grep file** searches the output of **ls** for the word **file**.

The **find** command illustrates why you might want separate handling for STDOUT and STDERR because it tends to produce output on both channels, especially when run as an unprivileged user.

For example:

```bash
$ find / -name my_unbelievably_important_file 2> /dev/null
# output
/home/abdou/unbelivable_directory/my_unbelievably_important_file
```

### Variables and quoting

You can assign a value to a variable using the **=** operator. Variable names are case-sensitive and may consist only of alphanumeric characters and underscores. 

When referencing a variable, you should enclose its name in curly braces to distinguish it from surrounding text. For example, **${var}**.

The shell treats strings enclosed in double quotes as a single argument, but it treats strings enclosed in single quotes as a series of characters. For example:

```bash
$ echo "Hello, $USER"
# output
Hello, abdou
$ echo 'Hello, $USER'
# output
Hello, $USER
```

Backticks are used to execute a command and substitute its output. For example:

```bash
$ echo "Today is `date`"
# output
Today is Tue  12 Mar 2024 17:03:34 CET
```

### Environment variables

Environment variables are automatically imported into **sh**'s variable namespace, so they can be set and read with standard variable syntax. Use the **export** command to make a variable available to child processes.

Despite being called "environment" variables, these values don’t exist in some abstract, ethereal place outside of space and time. The shell passes a snapshot of the current values to any program you run, but no ongoing connection exists. MOreover, every shell or program - and every terminal window - has its own distinct copy of the environment that can be separately modified.

Commands for environment variables that you want to set up at login time should be included in your **~/.profile** or **~/.bash_profile** file.

### Common filter commands

**cut** is used to extract sections from each line of input. For example:

```bash
$ echo "Hello, world" | cut -d " " -f 1
# output
Hello,
```

**sort** is used to sort lines of text. For example:

```bash
$ echo -e "b\na\nc" | sort -r
# output
c
b
a
```

- Sort options

| Option | Description                                  |
| ------ | -------------------------------------------- |
| **-r** | Reverse the result of comparisons.           |
| **-n** | Compare according to string numerical value. |
| **-f** | Fold lower case to upper case characters.    |
| **-u** | Output only the first of an equal run.       |
| **-t** | Specify a field separator.                   |
| **-k** | Sort by a key.                               |
| **-b** | Ignore leading blanks.                       |
| **-h** | Sort human readable numbers.                 |

```bash
$ du -sh /usr/* | sort -rh
# output
1.5G /usr/share
1.1G /usr/lib
890M /usr/bin
...
```

**uniq** is used to report or omit repeated lines. For example:

```bash
$ echo -e "a\na\nb" | uniq
# output
a
b
```

**wc** is used to print newline, word, and byte counts for each file. For example:

```bash
$ echo "Hello, world" | wc -w
# output
2
```

**tee** is used to read from standard input and write to standard output and files. For example:

```bash
$ echo "Hello, world" | tee file.txt
# output
Hello, world
$ cat file.txt
# output
Hello, world
```

A common idiom is to terminate a pipeline that will take a long time to run with a tee command. This way, you can see the output as it is generated and also save it to a file for later review.

**grep** is used to search for a pattern in each file. For example:

```bash
$ echo "Hello, world" | grep "world"
# output
Hello, world
```

- Grep options

| Option              | Description                                                                                    |
| ------------------- | ---------------------------------------------------------------------------------------------- |
| **-i**              | Ignore case. For example, **grep -i "hello"** matches **hello**, **Hello**, and **HELLO**.     |
| **-v**              | Invert the match. For example, **grep -v "hello"** matches lines that don't contain **hello**. |
| **-c**              | Count the number of matches. For example, **grep -c "hello"** counts the number of **hello**.  |
| **-n**              | Show the line number of each match. For example, **grep -n "hello"** shows line numbers.       |
| **-r**              | Recursively search directories. For example, **grep -r "hello" /path/to/directory**.           |
| **-w**              | Match whole words. For example, **grep -w "hello"** matches **hello** but not **hello123**.    |
| **-l**              | Show only the names of files with matches. For example, **grep -l "hello"**.                   |
| **-L**              | Show only the names of files without matches. For example, **grep -L "hello"**.                |
| **-o**              | Show only the matching part of the line. For example, **grep -o "hello"**.                     |
| **-E**              | Use extended regular expressions. For example, **grep -E "[0-9]"** matches numbers.            |
| **-A**              | Show lines after the match. For example, **grep -A 3 "hello"** shows the next 3 lines.         |
| **-B**              | Show lines before the match. For example, **grep -B 3 "hello"** shows the previous 3 lines.    |
| **--line-buffered** | Flush output on every line. For example, **grep --line-buffered "hello"**.                     |

## SH Scripting

**sh** is great for simple scripts that automate things you'd otherwise be typing on the command line. 

**sh** starts with a shebang line that specifies the path to the shell that should be used to run the script. **/bin/sh** is the standard path, but you can use **/bin/bash** or **/bin/dash** if you need features specific to those shells, or **/usr/bin/env** to use the user's preferred shell.

To prepare a script for execution, you need to set the execute bit with the **chmod** command. For example:

```bash
$ chmod +x helloworld

$ ./helloworld
# output
Hello, world!
```

If the shell understands the **helloworld** command without the **./** prefix, it's because the **PATH** environment variable includes the current directory. This is a security risk, so it's best to use the **./** prefix.

You can invoke the shell as an interpreter directly:

```bash
$ sh helloworld
# output
Hello, world!

$ source helloworld
# output
Hello, world!
```

The first command runs the script in a subshell, so any changes to the environment are lost when the script finishes. The second command runs the script in the current shell, so any changes to the environment persist after the script finishes.

**RQ**: The dot (**.**) command is a synonym for **source**. (e.g **. helloworld**)

### Input and output

You can use the **read** command to read a line of input from the user. For example:

```bash
#!/bin/sh

echo "What is your name?"
read name

if [ -z "$name" ]; then
  echo "You didn't tell me your name."
else
  echo "Hello, $name!"
fi
```

### Arguments and functions

You can use the **$1**, **$2**, **$3**, and so on to access the arguments to the script. The variable **$#** contains the number of arguments, and the variable **$@** contains all the arguments.

For example:

```bash
#!/bin/sh

show_usage() {
  echo "Usage: $0 source_dir dest_dir" > 1>&2
  exit 1
}

if [ $# -ne 2 ]; then
  show_usage
fi

else # There are two arguments
    if [ -d "$1" ]; then
      source_dir="$1"
    else
      echo "Error: $1 is not a directory." > 1>&2
      show_usage
    fi
    if [ -d "$2" ]; then
      dest_dir="$2"
    else
      echo "Error: $2 is not a directory." > 1>&2
      show_usage
    fi
fi

printf "Copying files from %s to %s\n" "$source_dir" "$dest_dir"

```

### Control flow

**if:**
You can use the **if**, **elif**, and **else** keywords to conditionally execute commands. For example:

```bash
#!/bin/sh

if [ -z "$1" ]; then
  echo "You didn't tell me your name."
elif [ "$1" = "abdou" ]; then
  echo "Hello, abdou!"
else
  echo "Hello, $1!"
fi
```

`-z` checks if the string is empty, and `-n` checks if the string is not empty.

- sh file evaluation operators:

| Operator        | True if                           |
| --------------- | --------------------------------- |
| **-d** file     | file exists and is a directory    |
| **-e** file     | file exists                       |
| **-f** file     | file exists and is a regular file |
| **-r** file     | file exists and is readable       |
| **-s** file     | file exists and is not empty      |
| **-w** file     | file exists and is writable       |
| file1 -nt file2 | file1 is newer than file2         |
| file1 -ot file2 | file1 is older than file2         |

**case:**

You can use the **case** keyword to conditionally execute commands based on pattern matching. For example:

```bash
#!/bin/sh

logMsg() {
  case $1 in
    info)
      echo "INFO: $2"
      ;;
    warning)
      echo "WARNING: $2" > 1>&2
      ;;
    error)
      echo "ERROR: $2" > 1>&2
      ;;
    *)
      echo "Unknown log level: $1" > 1>&2
      exit 1
      ;;
  esac
}
```

### Loops

**for:**

You can use the **for** keyword to iterate over a list of items. For example:

```bash
#!/bin/sh

for file in *.txt; do
  echo "Processing $file"
done
```

On more familiar **for** loop from traditional programming languages.

```bash
#!/bin/sh

for ((i=0; i<10; i++)); do
  echo "Processing $i"
done
```

**while:**

You can use the **while** keyword to execute commands as long as a condition is true. For example:

```bash
#!/bin/sh

exec 0<$1 # Redirects file descriptor 0 to the file named by $1

counter=1

while read line; do
  echo "Line $counter: $line"
  counter=$((counter + 1))
done
```

The **exec** command is used to redirect file descriptors. In this case, it redirects file descriptor 0 to the file named by **$1**.

### Arithmetic

All variables in **sh** are strings, so **sh** does not distinguish between the number 1 and the character string "1".

You can use the **expr** command to perform arithmetic operations or the **$((...))** syntax. For example:

```bash
#!/bin/sh

a=1
b=2

sum=$(expr $a + $b)
echo "The sum is $sum"

sum=$((a + b))
echo "The sum is $sum"
```

## Regular Expressions

As we mentioned here, regular expressions are standardized patterns that parse and manipulate text.

Regular expressions are supported by most modern languages, though some take them more to heart than others. They’re also used by UNIX commands such as **grep** and **vi**. 

Regular expressions are not themselves a scripting language, but they’re so useful that they merit featured coverage in any discussion of scripting; hence, this section.

### Special characters

| Symbol           | Description(Matches)                             |
| ---------------- | ------------------------------------------------ |
| **.**            | Any character except newline.                    |
| **^**            | The start of the line.                           |
| **[chars]]**     | Any character in a given set                     |
| **[^chars]**     | Any character not in a given set                 |
| **$**            | The end of a line                                |
| **\w**           | Any word character (same as [A-Za-z0-9_])        |
| **\s**           | Any whitespace character (same as [ \t\n\r\f\v]) |
| **\d**           | Any digit (same as [0-9])                        |
| **\b**           | A word boundary                                  |
| **\W**           | Any non-word character                           |
| **\S**           | Any non-whitespace character                     |
| **\D**           | Any non-digit character                          |
| **\B**           | A non-word boundary                              |
| **(expr)**       | A grouped subexpression                          |
| **expr1\|expr2** | An alternative (expr1 or expr2)                  |
| **?**            | Zero or one of the preceding element             |
| **\***           | Zero or more of the preceding element            |
| **+**            | One or more of the preceding element             |
| **{n}**          | Exactly n of the preceding element               |
| **{n,}**         | n or more of the preceding element               |
| **{n,m}**        | Between n and m of the preceding element         |

For example `(I am the (walrus|egg man)\. ?){1,2}` matches the following strings:

- I am the walrus.
- I am the egg man.
- I am the walrus. I am the egg man.
- I am the egg man. I am the walrus.
- I am the walrus. I am the walrus.
- I am the egg man. I am the egg man.

You can use whitespace to separate logical groups and clarify relationships, just as you would in a procedural language. For example a more readable version of a regex that could match Mouammar Kadhafi (and all the other spellings of his name) might be:

```bash
M [ou] '? a m+ [ae] r     # First name: Mu'ammar, Moamar, etc.
\s                        # Whitespace; can't use a literal space here.
(                         # Group for optional last name prefix
    [AEae] l              #   Al, El, or el
    [-\s]                 #   Followed by either a dash or whitespace
)? 
[GKQ] h? [aeu]+           # Initial syllabe of last name: Kha, Qua, etc.
(                         # Group for consonants at start of 2nd syllabe
    [dtz] [dhz]?          # dd, dh, etc.
){1,2}                    # Group might occur twice, as in Quadhdhafi
af [iy]                   # afi or afy
```

## Revision control with Git

Mistakes are a fact of life. It’s important to keep track of configuration and code changes so that these changes cause problems, you can easily revert to a known-good state. Revision control systems are software tools that track, archive, and grant access to multiple revisions of files.

By far the most popular revision control system is **Git**, created by the one and only Linus Torvalds. Git is a distributed revision control system, which means that every working directory is a full-fledged repository with complete history and full version-tracking capabilities, not dependent on network access or a central server.

Example of a simple Git workflow:

```bash
$ pwd
/home/abdou
$ mkdir myproject && cd myproject
$ git init
Initialized empty Git repository in /home/abdou/myproject/.git/
$ cat > my-awesome-script.sh <<EOF
#!/bin/sh

echo "Hello, world!"

EOF
$ chmod +x my-awesome-script.sh
$ git add .
$ git commit -m "Initial commit"
[master (root-commit) 0e3f4e3] Initial commit
 1 file changed, 4 insertions(+)
 create mode 100755 my-awesome-script.sh
```

In the sequence above, git init creates the repository’s infrastructure by creating a .git directory in `/home/abdou/myproject`. The **git add .** command copies the current state of the working directory into the **"index"**, which is a staging area for the next commit. The **git add** really just means "**cp** from the working directory to the index". **git commit** then records the state of the index in the repository, along with a commit message that describes the changes.

Let's make a change to the script:

```bash
$ cat >> my-awesome-script.sh << EOF
echo "I can do everything!!"
EOF

$ git commit my-awesome-script.sh -m "Add awesome feature!!"
[main 53a3859] One more changes!
 1 file changed, 1 insertion(+)
```

Naming the modified files on the **git commit** command line bypasses Git's normal use of the index and creates a revision that includes only changes on the named files. If there's multiple files, you can use the **git commit -a** to commit all the changes.

Git does not track the ownership or permissions of files, but git does track the executable bit. If you commit a script as executable, it will be executable when you check it out on another system.