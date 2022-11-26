# python atari_dqn.py --task "PongNoFrameskip-v4"
# python atari_a2c_ppo.py --env-name "BreakoutNoFrameskip-v4" --algo a2c

# python atari_dqn.py --resume_path "log/PongNoFrameskip-v4/dqn/policy.pth" --watch --test_num 10 --task "PongNoFrameskip-v4"
# python atari_a2c_ppo.py --env-name "BreakoutNoFrameskip-v4" --algo a2c --resume_path "log/BreakoutNoFrameskip-v4/a2c/policy.pth" --watch --test_num 10

# python atari_dqn.py --task "PongNoFrameskip-v4" --invert_reward --epoch 1
python atari_adversarial_training_dqn.py --task "PongNoFrameskip-v4" --resume_path "log/PongNoFrameskip-v4/dqn/policy.pth" --logdir log_def --eps 0.01 --image_attack fgm --epoch 5

# python atari_adversarial_training_dqn.py --task "PongNoFrameskip-v4" --resume_path "log_def/PongNoFrameskip-v4/dqn/policy.pth" --eps 0.01 --image_attack fgm --target_model_path log/PongNoFrameskip-v4/dqn/policy.pth --watch --test_num 10
