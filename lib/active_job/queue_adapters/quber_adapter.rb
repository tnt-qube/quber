module ActiveJob
  module QueueAdapters
    class QuberAdapter

      def initialize options = {}
        @client ||= Quber::Client.new options
      end

      def enqueue(job, attributes = {})
        task = build_task(job, attributes)
        @client.put task
      end

      def enqueue_at(job, timestamp)
        enqueue job, scheduled_at: timestamp
      end

      private

        def build_task(job, attributes)
          { data: job.serialize, **attributes }
        end

    end
  end
end