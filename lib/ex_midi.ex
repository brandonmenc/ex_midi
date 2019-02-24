defmodule ExMidi do
  defmodule SysEx do
    # SysEx message start
    @msg_start 0xF0

    # SysEx message end
    @msg_end 0xF7

    def messages(data) when is_binary(data) do
      data
      |> :binary.split(<<@msg_end>>, [:global])
      # last item of :binary.split is an empty list, so remove it
      |> List.delete_at(-1)
      # :binary.split removes the message end byte, so we put it back
      |> Enum.map(&(&1 <> <<@msg_end>>))
    end

    def valid_message?(msg) when is_binary(msg) do
      :binary.first(msg) == @msg_start and :binary.last(msg) == @msg_end
    end

    # A valid SysEx file contains one or more valid messages - therefore,
    # like a single message, it should always start with F0 and end with F7.
    def valid_sysex?(data) when is_binary(data) do
      valid_message?(data)
    end

    def msg_contents(msg) when is_binary(msg) do
      unless valid_message?(msg), do: raise "not valid SysEx message"
      :binary.part(msg, {1, byte_size(msg) - 2})
    end
  end
end
