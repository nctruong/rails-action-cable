class GuruChannel < ApplicationCable::Channel

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def subscribed
    stream_from(stream)
    transmit(stream_state) if waiting?
  end

  def receive(data)
    message = to_json(data).fetch(:message)
    ActionCable.server.broadcast(stream, message)
  end

  private

  def stream
    "#{Guru::Streaming::STREAM_PREFIX}_#{job_slug}"
  end

  def job_slug
    params.fetch(:job_slug)
  end

  def to_json(data)
    JSON.parse(data.to_json, symbolize_names:true)
  end

  def stream_state
    Redis.current.get(stream)
  end

  def waiting?
    stream_state == 'wait'
  end
end
