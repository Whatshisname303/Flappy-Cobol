# Overview

Cobol is an extremely robust, scalable, ergonomic, blazingly fast programming language. It has been for decades and is still today used in production across the world. Despite its widespread use, Cobol is still underutilized and has a largely untapped potential in game development.

In order to handle rendering, this project uses raylib (which is unfortunately written in C rather than Cobol) along with some some convenient C bindings thanks to https://codeberg.org/glowiak/raylib-cobol. The bindings are in `raylib.c`, some input keycodes are in `rl-keys.cpy`, and `flapper.cbl` contains all the Cobol source code.

![game](https://github.com/user-attachments/assets/69f1f446-6824-4e7a-a69b-444bf0461a0a)

# Installation

Make sure you have [raylib](https://github.com/raysan5/raylib) installed as well as the [GnuCOBOL](https://gnucobol.sourceforge.io/) compiler.
```bash
sudo apt install gnucobol
# figure out raylib installation from their docs

git clone https://github.com/Whatshisname303/Flappy-Cobol
cd Flappy-Cobol
make
./flapper
```
I'm not a big C guy myself so I only bothered to get it working on Linux. I imagine its not hard to compile on other platforms.

# Development insights revealed by Cobol

Learning Cobol through this project has been a mind opening experience in terms of the development strategies and patterns which are uniquely enforced by Cobol.

## Sentences

Cobol is structured into divisions, sections, paragraphs, sentences, and statements. This structure obviously is more robust and makes more sense than languages today which only rely on functions or modules. Also, it is nice to read sentences that end with a period since this is how our brains are trained to read from everywhere else in life, so why should code be an exception?

In Cobol, it is good practice to put periods in logical places (just like you would in normal writing). Consider this code:

```cobol
set a to 5
set b to 6
set c to 10.
```

This is great since these 3 statements clearly make sense as one sentence. A programmer who hasn't written Cobol though and only has experiences with less logical languages such as C might instead think to end each statement with a period much like how C statements are ended with a semicolon.

```cobol
set a to 5.
set b to 6.
set c to 10.
```

While this code written in the procedure division would work fine, this would not work in all contexts. Consider adding an if-statement.

```cobol
if a = 1
  set a to 5.
  set b to 6.
  set c to 10.
end-if.
```
Now the period at the end of the line `set a to 5.` would cause Cobol to think the if statement is over since the if statements is a part of the sentence. But what if instead of a C programmer, there was a python programmer. They might approach this problem by continuing to write statements without ever caring to terminate them.

```cobol
if a = 1
  set a to 5
  set b to 6
  set c to 10
end-if
```

Now this code would work normally, although if this code was a part a paragraph, then this would cause an error since you it doesn't make sense to end a paragraph without a period.

```cobol
0100-Will-Error
  if a = 1
    set a to 5
    set b to 6
    set c to 10
  end-if

0200-Will-Work
  if a = 1
    set a to 5
    set b to 6
    set c to 10
  end-if.
```

So while I'm writing Cobol, I often find myself adding new code within loops or if statements while accidentally adding a period which breaks the control flow, or I find myself adding new lines to a paragraph without adding a period which makes the paragraph invalid. This is really great since other languages will let programmers be lazy by not forcing them to consider proper grammar, although Cobol makes sure that developers stay alert, and Cobol developers with many years of experience definitely become very good at this skill.

## Lots of options

Modern programming languages have made the mistake of simplifying the language features so that there is only one way to solve a problem. In spoken languages though, nobody thinks we should get rid of synonyms or try to take away different options of how to do things, so why should this apply to programming?

In Cobol, there are a lot of different ways to change a variable.

```cobol
* setting variables
set a to 5
move 5 to a
add 2 to 3 giving a
compute a = 5

* changing variables
add 5 to a
subtract -5 from a
compute a = a + 5

* loops
perform until a > 3
perform 0100-do-something 10 times
perform with test after varying a from 10 by 20 until a is greater than or equal to 100
* this last loop would need to be broken into multiple lines
* (cobol conveniently ignores anything too long to ensure clean code)
```

Modern programming langauges lack this entire level of depth and prose. In python, your only option would be to do something like `a = 5`, although in Cobol there are multiple ways of saying the same thing, so your code can be more expressive, conveying a different emotion depending on which words feel more appropriate.

## Inline expressions

This next feature probably had the largest impact on my project and is one of my favorite features of Cobol. In modern programming languages, you  may want to call a function, although you don't quite have the values calculated that you want to pass in yet. A python programmer might try to do something like this:

```python
doSomething(var + 2)
```

This is a code-smell since it's much better to have your variables entirely evaluated before you pass them to functions. In Cobol, the previous code would cause an error. The python programmer after hearing this might try to adjust their code to something like this:

```python
arg1 = var + 2
doSomething(arg1)
```

Still though, this is a code-smell. This one isn't as much the fault of the python programmer, more the python language for letting you evaluate expressions when defining variables. Cobol makes sure that you define all your variables in the data section at the top of your file. So the cleanest code the python programmer could produce would look something like this:

```python
###### Data Division ########
var = 0
arg1 = 0

###### Procedure Division ###

arg1 = var + 2
doSomething(arg1)
```

This is a much better solution than writing `doSomething(var + 2)`. I love this solution since it scales very well in a larger program with many function calls. In my project, by the end, I end up with a large list of function arguments in the data division which are assigned and used at various points throughout the program. This was **very enjoyable** to work with.

```cobol
data division
working-storage section

01 hello-world-arg-1 pic 9.
01 hello-world-arg-2 pic 9.
01 do-something-arg-1 pic 9.
01 do-something-arg-2 pic 9.
01 do-something-arg-3 pic 9.

procedure division

compute hello-world-arg-1 = 1 + 2
compute hello-world-arg-2 = 2 + 3

call "helloWorld" using
  by value hello-world-arg-1 hello-world-arg-2
end-call.

* ...

move 6 to do-something-arg-1
move 7 to do-something-arg-2
move 8 to do-something-arg-3

call "doSomething" using
  do-something-arg-1 do-something-arg-2 do-something-arg-3
end-call.
```

Overall, Cobol is a great tool for game development due to the many features and restrictions which ensure you improve as a developer and write clean code. As you can probably tell, I had a great experience learning and writing Cobol, and I would hope the same is possible for more people. I would encourage you to use Cobol even if it's in any other domain so that you can feel just as amazing as I felt while building this project.


