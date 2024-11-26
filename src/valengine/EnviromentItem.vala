using Valengine.Shapes;
using Valengine.Graphics;
namespace Valengine {
    public class EnvItem {
        public Rectangle rect;
        public bool blocking;
        public Color color;
        private Texture brickTexture;

        public EnvItem(float x, float y, float width, float height, bool blocking, Color color, string texturePath) {
            rect = new Rectangle(x, y, width, height);
            this.blocking = blocking;
            this.color = color;
            this.brickTexture = new Texture(texturePath); // Load the brick texture
        }

        public void draw() {
            // Calculate how many tiles are needed horizontally and vertically
            int tilesX = (int)(rect.width / brickTexture.width);
            int tilesY = (int)(rect.height / brickTexture.height);

            // Draw the texture tiled across the rectangle
            for (int i = 0; i < tilesX; i++) {
                for (int j = 0; j < tilesY; j++) {
                    Vector2 position = new Vector2(rect.x + i * brickTexture.width, rect.y + j * brickTexture.height);
                    // Inline conversion to Raylib.Vector2
                    Vector2 raylibPosition = new Vector2(position.x, position.y);
                    brickTexture.draw_from_vector(raylibPosition.get_iVector(), color);
                }
            }
        }
    }
}