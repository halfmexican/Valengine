using Valengine;

namespace Valengine {
    public class EnemyBody : CharacterBody {
        public EnemyBody(float x, float y, string sprite_path) {
            base(x, y, 64, 64);
            // Load the enemy penguin spritesheet
            load_sprite(sprite_path + "/penguin_enemy.png", 32, 32, 4);
        }

        public override void update(float delta) {
            const float ENEMY_SPEED = 50.0f;

            // Simple horizontal movement between x = 300 and x = 500
            if (position.x <= 300) {
                velocity.x = ENEMY_SPEED;
            } else if (position.x >= 500) {
                velocity.x = -ENEMY_SPEED;
            }

            position.x += velocity.x * delta;

            // Update the sprite animation
            if (velocity.x != 0) {
                facing_left = velocity.x < 0;
                sprite_sheet?.update();
            }
        }

        public override void draw() {
            sprite_sheet?.draw(position, facing_left, 2.0f);
        }
    }
}
