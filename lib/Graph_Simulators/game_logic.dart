import 'dart:math';

enum TileType { empty, animal, obstacle, tool, exit }

class Tile {
  final int x;
  final int y;
  TileType type;
  bool visited;

  Tile(this.x, this.y, this.type) : visited = false;
}

class Forest {
  final int rows;
  final int cols;
  final List<List<Tile>> grid;
  final Random random = Random();
  int animalsRescued = 0;
  int totalAnimals = 3; // You can adjust this based on the game's difficulty
  int toolsCollected = 0;

  Forest(this.rows, this.cols) : grid = [] {
    for (int i = 0; i < rows; i++) {
      List<Tile> row = [];
      for (int j = 0; j < cols; j++) {
        row.add(Tile(i, j, TileType.empty));
      }
      grid.add(row);
    }
    _populateForest();
  }

  void _populateForest() {
    // Randomly place animals, obstacles, tools, and the exit
    _placeItem(TileType.exit, 1);
    _placeItem(TileType.animal, totalAnimals);
    _placeItem(TileType.obstacle, 5); // Random number of obstacles
    _placeItem(TileType.tool, 3); // Random number of tools
  }

  void _placeItem(TileType type, int count) {
    for (int i = 0; i < count; i++) {
      int x = random.nextInt(rows);
      int y = random.nextInt(cols);
      if (grid[x][y].type == TileType.empty) {
        grid[x][y].type = type;
      } else {
        i--; // Retry if the tile is already occupied
      }
    }
  }
}

class ForestExplorer {
  Forest forest;
  List<Tile> path = [];
  bool foundExit = false;

  ForestExplorer(this.forest);

  bool explore(Tile tile) {
    // Skip exploration if the tile is already visited or is an obstacle without a tool
    if (tile.visited ||
        (tile.type == TileType.obstacle && forest.toolsCollected == 0)) {
      return false;
    }

    tile.visited = true;
    path.add(tile);

    if (tile.type == TileType.exit &&
        forest.animalsRescued == forest.totalAnimals) {
      foundExit = true;
      return true;
    }

    // Collect animals or tools as needed
    if (tile.type == TileType.animal) {
      forest.animalsRescued++;
      print("Rescued an animal at (${tile.x}, ${tile.y})!");
    } else if (tile.type == TileType.tool) {
      forest.toolsCollected++;
      print("Collected a tool at (${tile.x}, ${tile.y})!");
    }

    // Explore neighboring tiles
    List<Tile> neighbors = _getNeighbors(tile);
    for (Tile neighbor in neighbors) {
      if (explore(neighbor)) return true;
    }

    // Backtrack if no path to exit was found from this tile
    path.removeLast();
    return false;
  }

  List<Tile> _getNeighbors(Tile tile) {
    List<Tile> neighbors = [];
    int x = tile.x;
    int y = tile.y;

    if (x > 0) neighbors.add(forest.grid[x - 1][y]); // Up
    if (y > 0) neighbors.add(forest.grid[x][y - 1]); // Left
    if (x < forest.rows - 1) neighbors.add(forest.grid[x + 1][y]); // Down
    if (y < forest.cols - 1) neighbors.add(forest.grid[x][y + 1]); // Right

    return neighbors;
  }
}
