using Valengine;
using Valengine.Shapes;
using Valengine.Input;
using Valengine.Audio;
namespace Valengine {
    public class PlatformerBody : PlayerBody {
        private const float PLAYER_JUMP_SPEED = 300.0f;
        private const float PLAYER_HORIZONTAL_SPEED = 200.0f;
        private const float GRAVITY = 400.0f;
        private const float PLAYER_SCALE = 2.0f;
        protected Sound ? jump_sound;
        public Gamepad ? gamepad;
        private ControlMapping player_input;

        public PlatformerBody (float x, float y) {
            base (x, y, 64, 64);
            player_input = new ControlMapping ();
        }

        public PlatformerBody.for_gamepad (float x, float y, Gamepad gamepad) {
            base (x, y, 64, 64);
            this.gamepad = gamepad;
            player_input = new ControlMapping ();
        }

        public void update_player (float delta, EnvItem[] env_items) {
            // Horizontal movement
            if (player_input.is_action_down (PlayerAction.MOVE_LEFT, gamepad)) {
                position.x -= PLAYER_HORIZONTAL_SPEED * delta;
                velocity.x = -PLAYER_HORIZONTAL_SPEED;
            } else if (player_input.is_action_down (PlayerAction.MOVE_RIGHT, gamepad)) {
                position.x += PLAYER_HORIZONTAL_SPEED * delta;
                velocity.x = PLAYER_HORIZONTAL_SPEED;
            } else {
                velocity.x = 0; // Stop horizontal movement if no key or button is pressed
            }

            // Jumping
            if (player_input.is_action_down (PlayerAction.JUMP, gamepad) && can_jump) {
                this.speed = -PLAYER_JUMP_SPEED;
                this.can_jump = false;
                if (jump_sound != null)jump_sound.playing = true;
            }

            bool hit_obstacle = false;
            foreach (var ei in env_items) {
                if (ei.blocking &&
                    ei.rect.x <= position.x &&
                    ei.rect.x + ei.rect.width >= position.x &&
                    ei.rect.y >= position.y &&
                    ei.rect.y <= position.y + speed * delta) {
                    hit_obstacle = true;
                    speed = 0.0f;
                    position.y = ei.rect.y;
                    break;
                }
            }

            if (!hit_obstacle) {
                position.y += speed * delta;
                speed += GRAVITY * delta;
                can_jump = false;
            } else {
                can_jump = true;
            }
        }

        public void set_jump_sound (Sound sound) {
            this.jump_sound = sound;
        }

        public override void draw () {
            sprite_sheet ?.draw (position, facing_left, PLAYER_SCALE);
        }
    }
}
