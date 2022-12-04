
start="python atari_dqn.py --task "
end="-v4 --device cuda:0"

# start="python atari_a2c_ppo.py --env-name "
# end="-v4  --algo a2c --device cuda:0"

# start="python atari_a2c_ppo.py --env-name "
# end="-v4 --device cuda:1 --algo ppo --use-gae --lr 2.5e-4 --clip-param 0.1 --value-loss-coef 0.5 --num-processes 8 --num-steps 128 --num-mini-batch 4 --log-interval 1 --use-linear-lr-decay --entropy-coef 0.01"


# python atari_adversarial_training_a2c_ppo.py --env-name "PongNoFrameskip-v4" --algo a2c --resume_path "log_def/PongNoFrameskip-v4/a2c/policy.pth" --eps 0.01 --image_attack fgm --target_model_path "log/PongNoFrameskip-v4/a2c/policy.pth" --watch --test_num 10

# Train 
log_filename=Train-adversarial_training_a2c_ppo
start="python atari_adversarial_training_a2c_ppo.py --env-name "
mid="-v4 --num-env-steps 10000000 --algo a2c --resume_path log/"
end="-v4/a2c/policy.pth --save-dir log_def --eps 0.01 --image_attack fgm --num-processes 16 --test_num 10 --device cuda:0"

# Test 
# log_filename=Test-adversarial_training_a2c_ppo
# start="python atari_adversarial_training_a2c_ppo.py --env-name "
# mid1="-v4 --algo a2c --resume_path log_def/"
# mid2="-v4/a2c/policy.pth --eps 0.01 --image_attack fgm --target_model_path log/"
# end="-v4/a2c/policy.pth --watch --test_num 10 --device cuda:0 --num-processes 1"

noGames=1

# Define a list of string variable
# stringList=("PongNoFrameskip" "BreakoutNoFrameskip" "EnduroNoFrameskip" "QbertNoFrameskip" "MsPacmanNoFrameskip" "SpaceInvadersNoFrameskip" "SeaquestNoFrameskip")
# stringList=("EnduroNoFrameskip" "QbertNoFrameskip" "MsPacmanNoFrameskip" "SpaceInvadersNoFrameskip" "SeaquestNoFrameskip")
# stringList=("BreakoutNoFrameskip" "SeaquestNoFrameskip" "EnduroNoFrameskip" "MsPacmanNoFrameskip")
stringList=("EnduroNoFrameskip")

for ((j = 0; j<noGames;j++))
do
    # cmd=${start}${stringList[$j]}${end}
    cmd=${start}${stringList[$j]}${mid}${stringList[$j]}${end}>${log_filename}_${stringList[$j]}.txt
    # cmd=${start}${stringList[$j]}${mid1}${stringList[$j]}${mid2}${stringList[$j]}${end}
    # cmd=${start}${stringList[$j]}${mid1}${stringList[$j]}${mid2}${stringList[$j]}${end}>${log_filename}_${stringList[$j]}.txt
    cmd_array+=("$cmd")
    let "commands_count+=1"
    echo $cmd
done

# start of the commands list is always zero
start=0
# count the total number of commands
commands_count=0
end=$(($start + $noGames))

# Run in parallel
while [ $start -lt $end ]; do {
cmd="${cmd_array[start]}"
echo "Process \"$start\" \"$cmd\" started";
$cmd & pid=$!
PID_LIST+=" $pid";
start=$(($start + 1))
} done

trap "kill $PID_LIST" SIGINT
echo "Parallel processes have started";
wait $PID_LIST
echo -e "\nAll processes have completed";

# reset the commands count
commands_count=0
# shift your commands array to the left for the tasks you already ran
cmd_array=("${cmd_array[@]:$num_parallel_tasks}")

# shift your PID list (clear it)
PID_LIST=("${PID_LIST[@]:$num_parallel_tasks}")

