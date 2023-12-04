class ApplicationsUpdateWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, params)
        params = JSON.parse params
        @application = Application.where(token: token).first
        @application.update(params)
    end
end