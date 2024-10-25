# Valengine executable
if get_option('valengine') == true
    executable(
        'valengine',
        dependencies: [valengine_dep],
        sources: [
            'examples/vengine_oop.vala',
            'meta/license.vala',
            'meta/version.vala',
        ],
        install: true,
    )
endif

# SnakeGame executable
if get_option('valengine') == true
    executable(
        'snakegame',
        dependencies: [valengine_dep],
        sources: [
            'examples/snake.vala',
        ],
        install: true,
    )
endif

