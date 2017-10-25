defmodule GossipSimulator.PushSum_Full_Actor do
    use GenServer
    require Logger

    @node_registry_name :node_registry

    def start_link(node_id,neighboursCount,nodes_to_ping) when is_integer(node_id) do
        GenServer.start_link(__MODULE__, [node_id,neighboursCount,nodes_to_ping], name: via_tuple(node_id))
    end

    # registry lookup handler
    defp via_tuple(node_id), do: {:via, Registry, {@node_registry_name, node_id}}

    def whereis(node_id) do
        case Registry.lookup(@node_registry_name, node_id) do
        [{pid, _}] -> pid
        [] -> nil
        end
    end

    def init([node_id,neighboursCount,nodes_to_ping]) do
        receive do
            {_,s,w} -> rumoringProcess = Task.start fn -> start_gossiping(node_id,neighboursCount,s+node_id,w+1,nodes_to_ping) end
                       node(1,s+node_id,w+1,node_id,rumoringProcess)
        end
        {:ok, node_id}
    end

    def node(count,s,w,oldsbyw,rumoringProcess)  do
        newsbyw = s/w
        change = abs(newsbyw - oldsbyw)
        count = if change > :math.pow(10,-10), do: 0, else: count + 1
        if count>=3 do
            send(:global.whereis_name(:mainproc),{:converged,self()})
            Task.shutdown(rumoringProcess,:brutal_kill)
        else
            s=s/2
            w=w/2
            send(elem(rumoringProcess,1),{:updaterumor,s,w})
            receive do
                {:transrumor,incomings,incomingw} -> node(count,incomings+s,incomingw+w,newsbyw,rumoringProcess)
            after
                100 -> node(count,s,w,newsbyw,rumoringProcess)
            end
        end
    end
    
    def start_gossiping(node_id,neighboursCount,s,w,nodes_to_ping) do
        try do
            {s,w} = receive do
                        {:updaterumor,updateds,updatedw} -> {updateds,updatedw}
                    end
            for _ <- 1..nodes_to_ping do
                seed = :rand.uniform(neighboursCount)
                neighbour_id = if seed < node_id, do: whereis(seed), else: whereis(seed+1)
                # Can be one way to handle failure scenario
                if neighbour_id != nil do
                    send(neighbour_id,{:transrumor,s,w})
                end
            end
            start_gossiping(node_id,neighboursCount,s,w,nodes_to_ping)
        rescue 
            _ -> start_gossiping(node_id,neighboursCount,s,w,nodes_to_ping)
        end
    end

end