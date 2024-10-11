using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class PlayerBody : Valengine.CharacterBody {
        private const float PLAYER_JUMP_SPD = 350.0f;
        private const float PLAYER_HOR_SPD = 200.0f;
        private const int G = 400;
        private MovementType movement_type = MovementType.PLATFORMER;
        public PlayerBody (float x, float y) {
            base (x, y, 40, 40, true);
        }

        public void update_player (float delta, List<EnvironmentItem> env_items) {
            Vector2 new_position = position;

            switch (movement_type) {
                case MovementType.PLATFORMER:
                    //new_position = 
                    update_platformer_movement (delta, env_items);
                    break;
                case MovementType.TOP_DOWN:
                    // new_position = update_top_down_movement(delta);
                    break;
                case MovementType.FREE_MOVE:
                    // new_position = update_free_move_movement(delta);
                    break;
                case MovementType.GRID_BASED:
                    // new_position = update_grid_based_movement(delta);
                    break;
            }

            bool hit_obstacle = false;
            foreach (var ei in env_items) {
                if (collides_with (ei, delta)) {
                    hit_obstacle = true;
                    speed = 0.0f;
                    new_position.y = ei.rect.y;
                    break;
                }
            }

            if (!hit_obstacle) {
                position = new_position;
                if (movement_type == MovementType.PLATFORMER) {
                    position.y += speed * delta;
                    speed += G * delta;
                    can_jump = false;
                }
            } else {
                if (movement_type == MovementType.PLATFORMER) {
                    can_jump = true;
                }
            }

            this.update (delta);
        }

        public override void draw () {
            // Draw player-specific visuals
            var center_rect = new Circle (position.x, position.y, 5.0f);
            center_rect.draw (Color.GOLD);
            collision_shape.draw ( Color.RED, null, 0);
            
            // Call base draw logic to draw the collision shape
            //base.draw ();
        }

        private void update_platformer_movement (float delta, List<EnvironmentItem> env_items) {
            if (Keyboard.is_down (Keyboard.Key.LEFT)) position.x -= PLAYER_HOR_SPD * delta;
            if (Keyboard.is_down (Keyboard.Key.RIGHT)) position.x += PLAYER_HOR_SPD * delta;
            if (Keyboard.is_down (Keyboard.Key.SPACE) && can_jump) {
                speed = -PLAYER_JUMP_SPD;
                can_jump = false;
            }
        }
    }
}