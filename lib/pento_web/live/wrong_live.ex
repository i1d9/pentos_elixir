defmodule PentoWeb.WrongLive do
    use PentoWeb, :live_view



    @doc """
    Responsible for setting the initial state(score and message)
    """
    def mount(_params, _session, socket) do
        random = Enum.random(1..10)
        {
            :ok,
            assign(
                socket,
                random: random,
                score: 0,
                correct: false,
                message: "Guess a number"
            )
        }
    end


    @doc """
    
    LiveView will render all the static markup once .

    """
    def render(assigns) do
        ~L"""
        <h1>Your score: <%= @score %> </h1>
        <h2> <%= @message %> </h2>
        It's <%= time() %>
        <h2>
        
        <%= for n <- 1..10 do %>
            <a href="#" phx-click="guess" phx-value-number="<%= n %>"> <%= n %> </a>
        <% end %>

        <%= if @correct do%>
        <a href="#" phx-click="reset">Reload Game</a>
        <% end %>

        </h2>
        """
    end

    def time() do
        DateTime.utc_now |> to_string
    end


    @doc """
    Handle event 
    
    Handles the phx-click="guess" event

    phx-value-number is pattern matched on the second argument to get the data


    """
    def handle_event("guess", %{"number" => guess}=data, socket) do
        IO.inspect data
        message = "Your guess: #{guess}. Wrong. Guess again. "
        score = socket.assigns.score

        #The random number is an integer in the assigns while the response is a string
        random = to_string(socket.assigns.random)
        IO.puts "The correct answer is #{random}"
        cond do
            guess == random ->
                IO.puts "Correct"
                score = socket.assigns.score + 1
                {
                    :noreply,
                    assign(
                        socket,
                        correct: true,
                        message: "Your guess is correct",
                        score: score)}
            true ->
                IO.puts "Not correct"
                score = socket.assigns.score - 1
                {
                    :noreply,
                    assign(
                        socket,
                        message: message,
                        score: score)}
        end
    end


    @doc """    
    Handles the phx-click="reset" event

    """
    def handle_event("reset", _params, socket) do
        random = Enum.random(1..10)
        {
            :noreply,
            assign(
                socket,
                random: random,
                score: 0,
                correct: false,
                message: "Guess a number"
            )
        }
    end

end