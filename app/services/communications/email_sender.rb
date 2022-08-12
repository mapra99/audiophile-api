module Communications
  class EmailSender
    attr_reader :communication, :email_communication

    def initialize(topic:, sender:, recipient:, template_id:, template_data:, target: nil)
      self.topic = topic
      self.sender = sender
      self.recipient = recipient
      self.template_id = template_id
      self.template_data = template_data
      self.target = target
    end

    def call
      validate_topic
      validate_sender
      resolve_recipient

      build_personalization
      build_mail
      send_email

      create_communication
      create_email_communication
    end

    private

    attr_accessor :topic, :sender, :recipient, :template_id, :template_data, :personalization, :mail,
                  :response, :target
    attr_writer :communication, :email_communication

    def validate_topic
      raise Communications::InvalidTopic, topic if Communication::TOPICS.none?(topic)
    end

    def validate_sender
      raise Communications::InvalidSender, sender if EmailCommunication::SENDERS.none?(sender)
    end

    def resolve_recipient
      return if Rails.env.production?

      self.recipient = ENV.fetch('TEST_EMAILS_RECIPIENT', 'test@example.com')
    end

    def build_personalization
      personalization = SendGrid::Personalization.new
      personalization.add_to(SendGrid::Email.new(email: recipient))
      personalization.add_dynamic_template_data(template_data)

      self.personalization = personalization
    end

    def build_mail
      mail = SendGrid::Mail.new
      mail.from = SendGrid::Email.new(email: sender)
      mail.template_id = template_id
      mail.add_personalization(personalization)

      self.mail = mail
    end

    def send_email
      sendgrid_client = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY')).client
      response = sendgrid_client.mail._('send').post(request_body: mail.to_json)
      raise Communications::EmailNotSent, response.body unless /2\d\d/.match?(response.status_code)

      self.response = response
    rescue StandardError => e
      raise Communications::EmailNotSent, e.message
    end

    def create_communication
      self.communication = Communication.create!(topic: topic)
    end

    def create_email_communication
      self.email_communication = EmailCommunication.create!(
        communication: communication,
        target: target,
        sender: sender,
        recipient: recipient,
        template_id: template_id,
        template_data: template_data
      )
    end
  end
end
