defmodule GossipSimulator.Gossip_ImpTwoD_Actor do
    use GenServer
    require Logger

    @node_registry_name :node_registry

    def start_link(node_id,neighboursList,numNodes,nodes_to_ping) when is_integer(node_id) do
        GenServer.start_link(__MODULE__, [node_id,neighboursList,numNodes,nodes_to_ping], name: via_tuple(node_id))
    end

    # registry lookup handler
    defp via_tuple(node_id), do: {:via, Registry, {@node_registry_name, node_id}}

    def whereis(node_id) do
        case Registry.lookup(@node_registry_name, node_id) do
        [{pid, _}] -> pid
        [] -> nil
        end
    end

    def init([node_id,neighboursList,numNodes,nodes_to_ping]) do
        receive do
            {_,rumor} -> rumoringProcess = Task.start fn -> start_gossiping(node_id,neighboursList,rumor,numNodes,nodes_to_ping) end
                         node(1,rumor,rumoringProcess)
        end
        {:ok, node_id}
    end

    def node(count,rumor,rumoringProcess)  do
        if(count < 10) do 
            receive do
                {:transrumor,rumor} -> node(count+1,rumor,rumoringProcess)
            end
        else
            send(:global.whereis_name(:mainproc),{:converged,self()})
            Task.shutdown(rumoringProcess,:brutal_kill)
        end
    end

    def start_gossiping(node_id,neighboursList,rumor,numNodes,nodes_to_ping) do
        for _ <- 1..nodes_to_ping do
            index = :rand.uniform(length(neighboursList)+1)-1
            neighbour_id =  if(index == length(neighboursList)) do
                                whereis(getrandomneighbour([node_id | neighboursList],numNodes))
                            else
                                whereis(Enum.at(neighboursList,index))
                            end
            
            # Can be one way to handle failure scenario
            if neighbour_id != nil do
                send(neighbour_id,{:transrumor,rumor})
            end
        end

        # Sleep for number of milliseconds
        Process.sleep(100)
        start_gossiping(node_id,neighboursList,rumor,numNodes,nodes_to_ping)
    end

    def getrandomneighbour(exceptList,numNodes) do
        randneigh = :rand.uniform(numNodes)
        if randneigh in exceptList do
           getrandomneighbour(exceptList,numNodes) 
        else
            randneigh
        end
    end
end