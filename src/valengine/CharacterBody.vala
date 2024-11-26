using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Graphics;
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
        protected SpriteSheet ? sprite_sheet;
        protected bool facing_left = false;

        protected CharacterBody (float x, float y, float width, float height, bool has_sprite = false) {
            this.position = new Vector2 (x, y);
            this.velocity = new Vector2 (0, 0);
            this.width = width;
            this.height = height;
        }

        public void load_sprite (string path, int frame_width, int frame_height, int frame_count) {
            sprite_sheet = new SpriteSheet (path, frame_width, frame_height, frame_count);
        }

        public virtual void update (float delta) {
            if (velocity.x != 0) {
                facing_left = velocity.x < 0;
                sprite_sheet ?.update ();
            }
        }

        public virtual void draw () {
            sprite_sheet ?.draw (position, facing_left, 1.0f);
        }
    }
}