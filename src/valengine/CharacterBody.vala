using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Graphics; // Import for Texture

namespace Valengine {
    public class CharacterBody : GLib.Object {
        public Vector2 position;
        public Vector2 velocity;
        public float width;
        public float height;
        public float speed;
        public bool can_jump;
        public Rectangle collision_shape;
        public bool is_blocking;
        public Texture ? sprite;

        protected Rectangle frame_rec;
        protected int current_frame = 0;
        protected int frames_counter = 0;
        protected int frames_speed = 3; // Number of frames per second
        private bool facing_left = false;

        protected CharacterBody (float x, float y, float width, float height, bool has_sprite = false) {
            this.position = new Vector2 (x, y);
            this.velocity = new Vector2 (0, 0); // Ensure velocity is initialized
            this.width = width;
            this.height = height;

            // Assuming the sprite sheet is 128x32 with 4 frames (32x32 each)
            this.frame_rec = new Rectangle (0, 0, 32, 32);
        }

        public void load_sprite (string path) {
            Image image = new Image (path);
            sprite = new Texture.from_image (image);
        }

        public virtual void update (float delta) {
            if (velocity.x != 0) { // Check if the player is moving horizontally
                if (velocity.x < 0) facing_left = true;
                else facing_left = false;
                frames_counter++;

                if (frames_counter >= (60 / frames_speed)) {
                    frames_counter = 0;
                    current_frame++;

                    if (current_frame > 3)current_frame = 0;   // Assuming 4 frames in the sprite sheet

                    frame_rec.x = (float) current_frame * frame_rec.width;
                }
                
            }
        }

        public virtual void draw () {
            if (sprite != null) {
                // Determine the origin for rotation and scaling
                Vector2 origin = new Vector2 (frame_rec.width / 2, frame_rec.height);
                float rotation = 0.0f;
                Color tint = Color.WHITE;

                // Use the facing_left variable to determine the sprite's orientation
                float source_width = facing_left ? -frame_rec.width : frame_rec.width;
                Rectangle source = new Rectangle (frame_rec.x, frame_rec.y, source_width, frame_rec.height);

                // Destination rectangle remains unchanged
                Rectangle destination = new Rectangle (position.x, position.y, frame_rec.width, frame_rec.height);

                // Draw the sprite with the adjusted source rectangle
                sprite.draw_pro (source, destination, origin, rotation, tint);
            }
        }
    }
}
