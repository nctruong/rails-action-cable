class Guru::Streaming
  attr_reader :job_slug

  STREAM_PREFIX = 'GuruChannel'
  MESSAGE = { wait: 'wait', reload: 'reload' }

  def initialize(job_slug)
    @job_slug = job_slug
  end

  def broadcast_waiting
    stream_wait
    broadcast(MESSAGE[:wait])
  end

  def broadcast_loading
    stream_reload
    broadcast(MESSAGE[:reload])
  end

  def wait?
    Redis.current.get(stream_name) == MESSAGE[:wait]
  end

  private

  def broadcast(message)
    ActionCable.server.broadcast(stream_name, message)
  end

  def stream_wait
    Redis.current.set(stream_name, MESSAGE[:wait])
  end

  def stream_reload
    Redis.current.set(stream_name, MESSAGE[:reload])
  end

  def stream_name
    "#{STREAM_PREFIX}_#{job_slug}"
  end
end
