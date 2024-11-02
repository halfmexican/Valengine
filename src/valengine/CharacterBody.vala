using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Graphics; // Import for Texture

namespace Valengine {
    public class CharacterBody : GLib.Object {
        public float width;
        public float height;
        public Vector2 position;
        public Vector2 velocity;
        public float speed;
        public bool can_jump;
        public Rectangle collision_shape;
        public bool is_blocking;
        public Texture ? sprite;

        private Rectangle frameRec;
        private int currentFrame = 0;
        private int framesCounter = 0;
        private int framesSpeed = 3; // Number of frames per second

        protected CharacterBody (float x, float y, float width, float height, bool has_sprite = false) {
            this.position = new Vector2 (x, y);
            this.width = width;
            this.height = height;

            // Assuming the sprite sheet is 128x32 with 4 frames (32x32 each)
            this.frameRec = new Rectangle (0, 0, 32, 32);
        }

        public void load_sprite (string path) {
            Image image = new Image (path);
            sprite = new Texture.from_image (image);
        }

        public virtual void update (float delta) {
            framesCounter++;

            if (framesCounter >= (60 / framesSpeed)) {
                framesCounter = 0;
                currentFrame++;

                if (currentFrame > 3)currentFrame = 0;  // Assuming 4 frames in the sprite sheet

                frameRec.x = (float) currentFrame * frameRec.width;
            }
        }

        public virtual void draw () {
            if (sprite != null) {
                Rectangle destination = new Rectangle (position.x, position.y, frameRec.width, frameRec.height);
                Vector2 origin = new Vector2 (frameRec.width / 2, frameRec.height);
                float rotation = 0.0f;
                Color tint = Color.WHITE;

                sprite.draw_pro (frameRec, destination, origin, rotation, tint);
            }
        }
    }
}