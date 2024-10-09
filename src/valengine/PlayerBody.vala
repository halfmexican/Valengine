using GLib;
using Valengine;
using Valengine.Shapes;
using Valengine.Input;

namespace Valengine {
    public class PlayerBody : Valengine.CharacterBody {
        private const float PLAYER_JUMP_SPD = 350.0f;
        private const float PLAYER_HOR_SPD = 200.0f;

        public PlayerBody (float x, float y) {
            base (x, y, 40, 40, true);
        }

        public override void update (float delta) {
            switch (movement_type) {
                case MovementType.PLATFORMER:
                    update_platformer_movement(delta);
                    break;
                case MovementType.TOP_DOWN:
                    update_top_down_movement(delta);
                    break;
                case MovementType.FREE_MOVE:
                    update_free_move_movement(delta);
                    break;
                case MovementType.GRID_BASED:
                    update_grid_based_movement(delta);
                    break;
            }

            base.update (delta);
        }

        public override void draw () {
            // Draw player-specific visuals
            var center_rect = new Circle (position.x, position.y, 5.0f);
            center_rect.draw (Color.GOLD);

            // Call base draw logic to draw the collision shape
            base.draw ();
        }
    }
}
