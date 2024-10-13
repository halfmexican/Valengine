using GLib;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class CharacterBody : GLib.Object {
        public Vector2 position;
        public float speed;
        public bool can_jump;
        public Rectangle collision_shape;
        public bool is_blocking;

        public CharacterBody (float x, float y, float width, float height, bool blocking) {
            position = new Vector2 (x, y);
            speed = 0;
            can_jump = false;
            collision_shape = new Rectangle (x, y, width, height);
            is_blocking = blocking;
        }

        public virtual void update (float delta) {
            // Update collision shape position
            collision_shape.x = position.x - collision_shape.width / 2;
            collision_shape.y = position.y - collision_shape.height / 2;

            // Common update logic for all character bodies
        }

        public virtual void draw () {
            // Draw the collision shape
            collision_shape.draw (is_blocking ? Color.GREEN : Color.RED, null, 0);
        }

        public bool collides_with (EnvironmentItem ei, float delta) {
            return (
                ei.blocking &&
                ei.rect.x <= position.x &&
                ei.rect.x + ei.rect.width >= position.x &&
                ei.rect.y >= position.y &&
                ei.rect.y <= position.y + speed * delta
            );
        }
    }
}