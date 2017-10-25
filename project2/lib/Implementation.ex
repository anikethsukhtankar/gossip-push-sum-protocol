defmodule GossipSimulator.Implementation do
    def gossip_full(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        for i <- 1..numNodes do
            pid = spawn(fn -> GossipSimulator.Gossip_Full_Actor.start_link(i,numNodes-1,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        gossip_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def gossip_2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        rowcnt = round(:math.sqrt(numNodes))
        for i <- 1..numNodes do 
            neighboursList =  cond do
                                    i == 1 -> [i+1,i+rowcnt]
                                    i == rowcnt -> [i-1,i+rowcnt]
                                    i == numNodes - rowcnt + 1 -> [i+1,i-rowcnt]
                                    i == numNodes -> [i-1,i-rowcnt]
                                    i < rowcnt -> [i-1,i+1,i+rowcnt]
                                    i > numNodes - rowcnt + 1 and i < numNodes -> [i-1,i+1,i-rowcnt]
                                    rem(i-1,rowcnt) == 0 -> [i+1,i-rowcnt,i+rowcnt]
                                    rem(i,rowcnt) == 0 -> [i-1,i-rowcnt,i+rowcnt]
                                    true -> [i-1,i+1,i-rowcnt,i+rowcnt]
                              end
            pid = spawn(fn -> GossipSimulator.Gossip_Default_Actor.start_link(i,neighboursList,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        gossip_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def gossip_line(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        for i <- 1..numNodes do
            neighboursList =  cond do
                                    i == 1 -> [i+1]
                                    i == numNodes -> [i-1]
                                    true -> [i-1,i+1]
                              end
            pid = spawn(fn -> GossipSimulator.Gossip_Default_Actor.start_link(i,neighboursList,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        gossip_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def gossip_imp2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        rowcnt = round(:math.sqrt(numNodes))
        for i <- 1..numNodes do
            neighboursList =  cond do
                                    i == 1 -> [i+1,i+rowcnt]
                                    i == rowcnt -> [i-1,i+rowcnt]
                                    i == numNodes - rowcnt + 1 -> [i+1,i-rowcnt]
                                    i == numNodes -> [i-1,i-rowcnt]
                                    i < rowcnt -> [i-1,i+1,i+rowcnt]
                                    i > numNodes - rowcnt + 1 and i < numNodes -> [i-1,i+1,i-rowcnt]
                                    rem((i-1),rowcnt) == 0 -> [i+1,i-rowcnt,i+rowcnt]
                                    rem(i,rowcnt) == 0 -> [i-1,i-rowcnt,i+rowcnt]
                                    true -> [i-1,i+1,i-rowcnt,i+rowcnt]
                              end
            pid = spawn(fn -> GossipSimulator.Gossip_ImpTwoD_Actor.start_link(i,neighboursList,numNodes,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        gossip_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def gossip_starter(numNodes,trigger_node_count,nodes_started) do
        if nodes_started < trigger_node_count do
            start_node = :rand.uniform(numNodes)
            start_node_id = GossipSimulator.Gossip_Default_Actor.whereis(start_node)
            if start_node_id != nil do
                send(start_node_id,{:mainproc,"Shikha is a Justin Bieber fan."})
                gossip_starter(numNodes,trigger_node_count,nodes_started+1)
            else
                gossip_starter(numNodes,trigger_node_count,nodes_started)
            end
        end
    end

    def pushsum_full(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        for i <- 1..numNodes do
            pid = spawn(fn -> GossipSimulator.PushSum_Full_Actor.start_link(i,numNodes-1,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        pushsum_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def pushsum_2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        rowcnt = round(:math.sqrt(numNodes))
        for i <- 1..numNodes do 
            neighboursList =  cond do
                                    i == 1 -> [i+1,i+rowcnt]
                                    i == rowcnt -> [i-1,i+rowcnt]
                                    i == numNodes - rowcnt + 1 -> [i+1,i-rowcnt]
                                    i == numNodes -> [i-1,i-rowcnt]
                                    i < rowcnt -> [i-1,i+1,i+rowcnt]
                                    i > numNodes - rowcnt + 1 and i < numNodes -> [i-1,i+1,i-rowcnt]
                                    rem(i-1,rowcnt) == 0 -> [i+1,i-rowcnt,i+rowcnt]
                                    rem(i,rowcnt) == 0 -> [i-1,i-rowcnt,i+rowcnt]
                                    true -> [i-1,i+1,i-rowcnt,i+rowcnt]
                              end
            pid = spawn(fn -> GossipSimulator.PushSum_Default_Actor.start_link(i,neighboursList,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        pushsum_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def pushsum_line(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        for i <- 1..numNodes do
            neighboursList =  cond do
                                    i == 1 -> [i+1]
                                    i == numNodes -> [i-1]
                                    true -> [i-1,i+1]
                              end
            pid = spawn(fn -> GossipSimulator.PushSum_Default_Actor.start_link(i,neighboursList,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        pushsum_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def pushsum_imp2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold) do
        rowcnt = round(:math.sqrt(numNodes))
        for i <- 1..numNodes do
            neighboursList =  cond do
                                    i == 1 -> [i+1,i+rowcnt]
                                    i == rowcnt -> [i-1,i+rowcnt]
                                    i == numNodes - rowcnt + 1 -> [i+1,i-rowcnt]
                                    i == numNodes -> [i-1,i-rowcnt]
                                    i < rowcnt -> [i-1,i+1,i+rowcnt]
                                    i > numNodes - rowcnt + 1 and i < numNodes -> [i-1,i+1,i-rowcnt]
                                    rem((i-1),rowcnt) == 0 -> [i+1,i-rowcnt,i+rowcnt]
                                    rem(i,rowcnt) == 0 -> [i-1,i-rowcnt,i+rowcnt]
                                    true -> [i-1,i+1,i-rowcnt,i+rowcnt]
                              end
            pid = spawn(fn -> GossipSimulator.PushSum_ImpTwoD_Actor.start_link(i,neighboursList,numNodes,nodes_to_ping) end)
            Process.monitor(pid)
        end
        convergence_task = Task.async(fn -> converging(numNodes,stopping_threshold) end)
        :global.register_name(:mainproc,convergence_task.pid)
        :global.register_name(:failurehelper,self())
        start_time = System.system_time(:millisecond)
        pushsum_starter(numNodes,trigger_node_count,0)
        fail_helper(numNodes,stopping_threshold)
        Task.await(convergence_task, :infinity)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
    end

    def pushsum_starter(numNodes,trigger_node_count,nodes_started) do
        if nodes_started < trigger_node_count do
            start_node = :rand.uniform(numNodes)
            start_node_id = GossipSimulator.PushSum_Default_Actor.whereis(start_node)
            if start_node_id != nil do
                send(start_node_id,{:mainsw,0,0})
                pushsum_starter(numNodes,trigger_node_count,nodes_started+1)
            else
                pushsum_starter(numNodes,trigger_node_count,nodes_started)
            end
        end
    end

    def fail_helper(numNodes,stopping_threshold) do
        if(numNodes > stopping_threshold) do
            receive do
            {:DOWN, _, :process, pid, :killed} -> IO.puts "#{inspect(pid)} killed"
                                                  fail_helper(numNodes,stopping_threshold)
            {:DOWN, _, :process, _pid, _reason} -> fail_helper(numNodes-1,stopping_threshold)
            end
        else
            nil
        end   
    end

    def converging(numNodes,stopping_threshold) do
      # Receive convergence messages for both algorithms
      if(numNodes > stopping_threshold) do
        receive do
            {:converged,pid} -> IO.puts "#{inspect(pid)} Converged #{numNodes}"
                                converging(numNodes-1,stopping_threshold)
        after
                5000 -> IO.puts "Convergence could not be reached for #{numNodes}"
                        # mock process shutdown
                        send(:global.whereis_name(:failurehelper),{:DOWN, :random, :process, :random, :cantconverge})
                        converging(numNodes-1,stopping_threshold)
        end
      else
        nil
      end
    end
end