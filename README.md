# 🧮 Polynomial Operations Library

## 📝 Description

This library provides a comprehensive set of functions for manipulating polynomials, implementing all basic and advanced mathematical operations. The library is accompanied by an interactive program that allows users to perform operations on polynomials through simple commands.

## ✨ Features

### 📊 Basic Operations

- 📥 Reading polynomials in standard mathematical format
- 📤 Displaying polynomials in mathematical format
- ➖ Negating a polynomial
- ✖️ Multiplying by a scalar
- ➕ Adding two polynomials
- ➖ Subtracting two polynomials

### 🔬 Advanced Operations

- ✖️ Multiplying two polynomials
- 🔄 Raising a polynomial to a power
- ➗ Dividing two polynomials
- 📈 Evaluating a polynomial at a point x
- 📉 Calculating the derivative of a polynomial
- 📊 Calculating the integral of a polynomial
- 🧩 Determining the greatest common divisor (GCD)
- 🧮 Determining the least common multiple (LCM)

## 🖥️ Usage

The program accepts the following commands:

```
<var> = anX^n + an-1X^(n-1) + ... + a1X + a0    # Defining a polynomial
write <var>                                     # Displaying a polynomial
<res> = -<var>                                  # Negating a polynomial
<res> = <value> * <var>                         # Multiplying by a scalar
<res> = <var1> + <var2>                         # Adding polynomials
<res> = <var1> - <var2>                         # Subtracting polynomials
<res> = <var1> * <var2>                         # Multiplying polynomials
<res> = <var> ^ <value>                         # Raising to a power
<quotient>, <remainder> = <var1> / <var2>       # Dividing polynomials
<var>(<value>)                                  # Evaluation at a point
<res> = d(<var>)                                # Derivative of the polynomial
<res> = i(<var>)                                # Integral of the polynomial
<res> = gcd(<var1>, <var2>)                     # Greatest common divisor
<res> = lcm(<var1>, <var2>)                     # Least common multiple
help                                            # Display available commands
exit                                            # Exit the program

```

## 📋 Examples

```
# Defining polynomials
p = 3X^2 + 2X + 1
q = X^3 - 4X + 7

# Basic Operations
write p                   # Displays: 3X^2 + 2X + 1
r = -p                    # r becomes: -3X^2 - 2X - 1
s = 2 * p                 # s becomes: 6X^2 + 4X + 2
t = p + q                 # t becomes: X^3 + 3X^2 - 2X + 8

# Advanced Operations
u = p * q                 # u becomes: 3X^5 + 2X^4 + X^3 - 12X^3 - 8X^2 - 4X + 21X^2 + 14X + 7
v = p ^ 2                 # v becomes: 9X^4 + 12X^3 + 10X^2 + 4X + 1
quotient, remainder = q / p    # Dividing q by p
p(2)                      # Evaluates p at x=2: 3*2^2 + 2*2 + 1 = 17
w = d(p)                  # w becomes: 6X + 2
z = i(p)                  # z becomes: X^3 + X^2 + X
```

## 🛠️ Implementation

The library is implemented in C++ and uses object-oriented programming concepts to ensure a modular and extensible structure:

- 🧬 The `Polynomial` class encapsulates the representation and behavior of polynomials
- 🔄 Operator overloading to allow natural syntax
- 🧮 Efficient algorithms for complex operations (multiplication, division, GCD)
- 🧪 A robust testing system to ensure correctness

## 📌 System Requirements

- 🖥️ C++ compiler with support for C++11 or later
- 📚 Standard Template Library (STL)

## 🚀 Compilation and Execution

```bash
# Compilation
g++ -std=c++11 -o polynomial main.cpp polynomial.cpp

# Execution
./polynomial
```
## 👥 Author

- 👩‍💻 Maria-Magdalena Creț


