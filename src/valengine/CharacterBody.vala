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

        public virtual void update (float delta, List<EnvironmentItem> env_items) {
            // Update collision shape position
            update_collision (new Vector2 (velocity.x * delta, velocity.y * delta), env_items);
            collision_shape.iRectangle.x = position.x - collision_shape.width / 2;
            collision_shape.iRectangle.y = position.y - collision_shape.height / 2;

            // Common update logic for all character bodies
        }

        public virtual void draw () {
            // Draw the collision shape
            collision_shape.draw (is_blocking ? Color.GREEN : Color.RED, null, 0);
        }

        public void update_collision (Vector2 velocity, List<EnvironmentItem> env_items) {
            // Predict the new position based on velocity
            Rectangle new_rect = collision_shape;
            new_rect.x += velocity.x;
            new_rect.y += velocity.y;

            // Collect potential collisions
            foreach (var env_item in env_items) {
                if (env_item.blocking && new_rect.intersects (env_item.rect)) {
                    // Collision resolution logic
                    // Handle collision on X axis
                    if (velocity.x != 0) {
                        if (velocity.x > 0) {
                            // Moving right
                            collision_shape.x = env_item.rect.x - collision_shape.width;
                        } else {
                            // Moving left
                            collision_shape.x = env_item.rect.x + env_item.rect.width;
                        }
                        velocity.x = 0;
                    }
                    // Handle collision on Y axis
                    if (velocity.y != 0) {
                        if (velocity.y > 0) {
                            // Moving down
                            collision_shape.y = env_item.rect.y - collision_shape.height;
                        } else {
                            // Moving up
                            collision_shape.y = env_item.rect.y + env_item.rect.height;
                        }
                        velocity.y = 0;
                    }
                }
            }

            // Update position after collision resolution
            position.x = collision_shape.x + collision_shape.width / 2;
            position.y = collision_shape.y + collision_shape.height / 2;
        }
    }
}
