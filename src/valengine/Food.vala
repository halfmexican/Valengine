using Valengine.Shapes;
namespace Valengine {
    public class Food : EnvItem {
        public int[] position;

        public Food (int rows, int cols, float x, float y, float width, float height, bool blocking, Color color, string texturePath) {
            base (x, y, width, height, blocking, color, texturePath) ;
            position = new int[2];
            respawn (rows, cols);
        }

        public void respawn (int rows, int cols) {
            position[0] = Random.int_range (0, rows - 1);
            position[1] = Random.int_range (0, cols - 1);
        }

        public void draw (int tile_size) {
            Rectangle food_rect = new Rectangle (
                position[0] * tile_size,
                position[1] * tile_size,
                tile_size,
                tile_size
            );
            food_rect.draw (Color.RED, null, 0.0f);
        }
    }
}
