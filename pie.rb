class Rectangle
  attr_accessor :x0, :x1, :y0, :y1

  def initialize(x0, x1, y0, y1)
    @x0 = x0
    @x1 = x1
    @y0 = y0
    @y1 = y1
  end
end

class Solution
  attr_accessor :piece

  def initialize
    @piece = []
  end

  def addPiece(piece)
    @piece << piece
  end

  def deletePiece(piece)
    @piece.delete(piece)
  end

  def getSolution
    return @piece
  end
end

class Cake
  def initialize(cake)
    @cakeMatrix = getMatrix(cake)
    @raisinCount = cake.count("o")
    @onePieceArea = getArea(@cakeMatrix) / @raisinCount
    @solutions = []
  end

  def getMatrix(cake)
    temp = cake.split("\n")
    cakeMatrix = []

    for i in 0..(temp.length - 1)
      cakeMatrix[i] = temp[i].split("")
    end

    return cakeMatrix
  end

  def getSubMatrix(matrix, x0, x1, y0, y1)
    matrix = @cakeMatrix if matrix.nil?

    subMatrix = []

    for i in 0..(y1 - y0)
      subMatrix[i] = []

      for j in 0..(x1 - x0)
        subMatrix[i][j] = matrix[i + y0][j + x0]
      end
    end

    return subMatrix
  end

  def getArea(matrix)
    return matrix.length * matrix[0].length
  end

  def printMatrix(matrix)
    for i in matrix
      print "\t"

      for j in i
        print j
      end

      puts ""
    end
  end

  def findSolutions()
    return nil if (getArea(@cakeMatrix) % @raisinCount != 0)

    solution = Solution.new

    cutCake(@cakeMatrix, solution)

    return @solutions
  end

  def cutCake(cakeMatrix, solution, xStart = 0, yStart = 0)
    x_start = xStart
    y_start = yStart

    for i in y_start..(cakeMatrix.length - 1)
      for j in x_start..(cakeMatrix[0].length - 1)

        if (i - yStart + 1) * (j - xStart + 1) == @onePieceArea && !pointInSolution(j, i, solution)
          subMatrix = getSubMatrix(cakeMatrix, xStart, j, yStart, i)

          if raisinCount(subMatrix) == 1
            newPiece = Rectangle.new(xStart, j, yStart, i)
            solution.addPiece(newPiece)

            newPoint = findNewStartPoint(solution, cakeMatrix)
            x = newPoint[0]
            y = newPoint[1]

            if x == -1 && y == -1
              addNewSolution(solution)
              solution.deletePiece(newPiece)

              return
            else
              cutCake(cakeMatrix, solution, x, y)
              solution.deletePiece(newPiece)
            end
          end
        elsif (i - yStart + 1) * (j - xStart + 1) > @onePieceArea
          break
        end
      end
    end
  end

  def addNewSolution(solution)
    newSolution = Solution.new

    for i in solution.getSolution
      newSolution.addPiece(i)
    end

    @solutions << newSolution
  end

  def findNewStartPoint(solution, matrix)
    x = -1
    y = -1

    for i in 0..(@cakeMatrix.length - 1)
      for j in 0..(@cakeMatrix[0].length - 1)
        x = j
        y = i

        for r in solution.getSolution
          if x.between?(r.x0, r.x1) && y.between?(r.y0, r.y1)
            x = -1
            y = -1
            break
          end
        end

        return x, y if x != -1 && y != -1
      end
    end

    return x, y
  end

  def pointInSolution(x, y, solution)
    for r in solution.getSolution
      if x.between?(r.x0, r.x1) && y.between?(r.y0, r.y1)
        return true
      end
    end

    return false
  end

  def raisinCount(cakeMatrix)
    count = 0

    for i in cakeMatrix
      for j in i
        count += 1 if j == "o"
      end
    end

    return count
  end
end


# testCake = "........\n" +
#             "..o.....\n" +
#             "...o....\n" +
#             "........\n"

testCake = ".o.o....\n" +
  "........\n" +
  "....o...\n" +
  "........\n" +
  ".....o..\n" +
  "........\n"

# testCake = ".o......\n" +
#             "......o.\n" +
#             "....o...\n" +
#             "..o.....\n"

test = Cake.new(testCake)

solutions = test.findSolutions()
sN = 1
pN = 1

puts "Task: "
puts testCake
puts ""

for i in solutions
  puts "Solutioin " + sN.to_s + ": "

  for j in i.getSolution
    puts "\tPart " + pN.to_s + ": "
    test.printMatrix(test.getSubMatrix(nil, j.x0, j.x1, j.y0, j.y1))
    puts ""

    pN += 1
  end

  puts ""
  sN += 1
  pN = 1
end
