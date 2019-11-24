# Game Of Life - Infinite World - PowerShell

PowerShell implementation of Comway's Game of Life with infinite world.
---

I've been playing around with Comway's Game of Life already with different languages and different implementations, but so far all my implementations were restricted to a finite two-dimensional world represented by a matrix in a form of array of arrays, or something similar. Sometimes world was like a tube or a sphere, i.e. top and bottom edges and sometimes also right and left edges were adjacent. But it was always finite.
However, on a recent code retreat I attended suddenly there came a requirement that world must be infinite. I found the problem very interesting and decided to implement the solution in PowerShell, as it is the language I currently use the most.

---

All code here was created using TDD approach (Test Driven Design), so before implementing each function a test suite was created for it. For test I used Pester. All tests are in ```GameOfLife.Tests.ps1``` script.

All functions that were tested (and that actually matter) are in ```GameOfLife.ps1``` script.

Additional functions for generating and displaying world and for running simulations are in ```GameOfLife.Helpers.ps1``` script.
