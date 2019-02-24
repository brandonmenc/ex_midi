defmodule ExMidi.Blofeld do
  def decode_message(msg) when is_binary(msg) do
    # F0h IDW IDE DEV IDM BB NN --------Data--------- CHK F7h
    # IDW = 3Eh
    # DEV = 13h

    <<0x3E, 0x13, dev_num, msg_id, bank, number, rest::binary>> = msg
    data_length = byte_size(rest) - 1
    data = :binary.part(rest, {0, data_length})
    checksum = :binary.at(rest, data_length)
    name = :binary.part(data, {363, 378 - 363})

    location =
      if bank <= 19 do
        location = <<?A + bank>> <> "#{number + 1}"
      end

    [
      dev_num: dev_num,
      msg_id: msg_id,
      bank: bank,
      number: number,
      data: data,
      checksum: checksum,
      name: name,
      location: location
    ]
  end
end
