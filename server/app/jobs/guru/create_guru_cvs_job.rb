class Guru::CreateGuruCvsJob < ApplicationJob
  queue_as :critical

  def perform(job)
    stream = Guru::Streaming.new(job.slug)

    stream.broadcast_waiting
    # Doing something here

    stream.broadcast_loading
  end
end
