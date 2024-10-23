using GLib;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class CharacterBody : GLib.Object {
        public Vector2 position;
        public Vector2 velocity;
        public float speed;
        public bool can_jump;
        public Rectangle collision_shape;
        public bool is_blocking;

        public CharacterBody (float x, float y, float width, float height, bool blocking) {
            position = new Vector2 (x, y);
            velocity = new Vector2 (0, 0);
            speed = 0;
            can_jump = false;
            collision_shape = new Rectangle (x, y, width, height);
            is_blocking = blocking;
        }

        public virtual void update (float delta) {
            // Update position based on velocity
            position.x += velocity.x * delta;
            position.y += velocity.y * delta;

            // Update collision shape position
            collision_shape.x = position.x;
            collision_shape.y = position.y;
        }

        public virtual void draw () {
            collision_shape.draw (is_blocking ? Color.GREEN : Color.RED, null, 0);
        }
    }
}