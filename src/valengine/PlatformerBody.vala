using Valengine;
using Valengine.Shapes;
using Valengine.Input;
using Valengine.Audio;
namespace Valengine {
    public class PlatformerBody : PlayerBody {
        private const float PLAYER_JUMP_SPEED = 350.0f;
        private const float PLAYER_HORIZONTAL_SPEED = 200.0f;
        private const float GRAVITY = 400.0f;
        public Sound ? jump_sound;

        public PlatformerBody (float x, float y) {
            base (x, y, 40, 40);
            string sound_path = Path.build_filename (Environment.get_current_dir (), "src/valengine/audio/");
            jump_sound = new Sound (sound_path + "jump.ogg");
        }

        public void update_player (float delta, EnvItem[] env_items) {
            if (Keyboard.is_down (Keyboard.Key.LEFT)) {
                position.x -= PLAYER_HORIZONTAL_SPEED * delta;
                velocity.x = -PLAYER_HORIZONTAL_SPEED;
            } else if (Keyboard.is_down (Keyboard.Key.RIGHT)) {
                position.x += PLAYER_HORIZONTAL_SPEED * delta;
                velocity.x = PLAYER_HORIZONTAL_SPEED;
            } else {
                velocity.x = 0; // Stop horizontal movement if no key is pressed
            }

            if (Keyboard.is_down (Keyboard.Key.SPACE) && can_jump) {
                this.speed = -PLAYER_JUMP_SPEED;
                this.can_jump = false;
                jump_sound.playing = true;
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
        public override void draw () {
            base.draw ();
            // Additional drawing code if needed
        }
    }
}
