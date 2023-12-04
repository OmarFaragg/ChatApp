class ApplicationsCreationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
        params = JSON.parse params
        @new_application = Application.new(params)
        @new_application.save
    end
end
