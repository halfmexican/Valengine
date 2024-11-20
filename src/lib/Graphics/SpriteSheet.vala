using Valengine.Graphics;
using  Valengine.Shapes; 
namespace Valengine {
    public class SpriteSheet {
        public Texture ? texture;
        public int frame_count;
        public int current_frame = 0;
        public int frames_counter = 0;
        public int frames_speed = 3;
        public Rectangle frame_rec;

        public SpriteSheet (string path, int frame_width, int frame_height, int frame_count) {
            Image image = new Image (path);
            texture = new Texture.from_image (image);
            this.frame_count = frame_count;
            this.frame_rec = new Rectangle (0, 0, frame_width, frame_height);
        }

        public void update () {
            frames_counter++;

            if (frames_counter >= (60 / frames_speed)) {
                frames_counter = 0;
                current_frame++;

                if (current_frame >= frame_count)current_frame = 0;

                frame_rec.x = (float) current_frame * frame_rec.width;
            }
        }

        public void draw (Vector2 position, bool facing_left) {
            if (texture != null) {
                Vector2 origin = new Vector2 (frame_rec.width / 2, frame_rec.height);
                float rotation = 0.0f;
                Color tint = Color.WHITE;

                float source_width = facing_left ? -frame_rec.width : frame_rec.width;
                Rectangle source = new Rectangle (frame_rec.x, frame_rec.y, source_width, frame_rec.height);
                Rectangle destination = new Rectangle (position.x, position.y, frame_rec.width, frame_rec.height);

                texture.draw_pro (source, destination, origin, rotation, tint);
            }
        }
    }
}
