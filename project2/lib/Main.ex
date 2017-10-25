defmodule GossipSimulator.Main do
    def main(args) do
      args |> parse_args |> delegate
    end

    defp parse_args(args) do
      {_,parameters,_} = OptionParser.parse(args)
      parameters
    end
    
    def delegate([]) do
      IO.puts "No arguments given"
    end

    def delegate(parameters) do
      n = String.to_integer(Enum.at(parameters,0))
      topology = Enum.at(parameters,1)
      algorithm = Enum.at(parameters,2)
      trigger_node_count = if Enum.at(parameters,3) != nil do
        String.to_integer(Enum.at(parameters,3))
      else
        1
      end
      stopping_threshold = if Enum.at(parameters,4) != nil do
        String.to_integer(Enum.at(parameters,4))
      else
        0
      end
      #nodes_to_ping = String.to_integer(Enum.at(parameters,5))
      nodes_to_ping = 1
      # Rounding up to get a square for 2D based topologies
      numNodes=if String.contains?(topology,"2d"), do: round(:math.pow(round(:math.sqrt(n)),2)), else: n
      Registry.start_link(keys: :unique, name: :node_registry)
      case topology do
        "full" -> if algorithm == "gossip", do: GossipSimulator.Implementation.gossip_full(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold), else: GossipSimulator.Implementation.pushsum_full(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold)
        "2d" -> if algorithm == "gossip", do: GossipSimulator.Implementation.gossip_2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold), else: GossipSimulator.Implementation.pushsum_2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold)
        "line" -> if algorithm == "gossip", do: GossipSimulator.Implementation.gossip_line(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold), else: GossipSimulator.Implementation.pushsum_line(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold)
        "imp2d" -> if algorithm == "gossip", do: GossipSimulator.Implementation.gossip_imp2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold), else: GossipSimulator.Implementation.pushsum_imp2d(numNodes,trigger_node_count,nodes_to_ping,stopping_threshold)
        _ -> IO.puts "Default"
      end
    end
end