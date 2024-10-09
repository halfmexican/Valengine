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
            if (Keyboard.is_down (Keyboard.Key.LEFT))position.x -= PLAYER_HOR_SPD * delta;
            if (Keyboard.is_down (Keyboard.Key.RIGHT))position.x += PLAYER_HOR_SPD * delta;
            if (Keyboard.is_down (Keyboard.Key.SPACE) && can_jump) {
                speed = -PLAYER_JUMP_SPD;
                can_jump = false;
            }

            // Call base update logic
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
