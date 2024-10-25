using Valengine;
using Valengine.Shapes;
using Valengine.Input;
namespace Valengine {
    public class PlatformerBody : PlayerBody {
        private const float PLAYER_JUMP_SPEED = 350.0f;
        private const float PLAYER_HORIZONTAL_SPEED = 200.0f;
        private const float GRAVITY = 400.0f;

        public PlatformerBody (float x, float y) {
            base (x, y, 40, 40);
        }

        public override void update (float delta) {
            // Horizontal movement
            if (Keyboard.is_down (Keyboard.Key.LEFT))
                velocity.x = -PLAYER_HORIZONTAL_SPEED;
            else if (Keyboard.is_down (Keyboard.Key.RIGHT))
                velocity.x = PLAYER_HORIZONTAL_SPEED;
            else
                velocity.x = 0;

            // Jumping
            if (Keyboard.is_down (Keyboard.Key.SPACE) && can_jump) {
                velocity.y = -PLAYER_JUMP_SPEED;
                can_jump = false;
            }

            // Apply gravity
            velocity.y += GRAVITY * delta;

            // Update position
            base.update (delta);
        }

        public override void draw () {
            base.draw ();
            // Additional drawing code if needed
        }
    }
}
