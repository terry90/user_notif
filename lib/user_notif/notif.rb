require 'active_record'

module UserNotif
  class Notif < ActiveRecord::Base
    belongs_to :target, polymorphic: true
    belongs_to :user

    scope :unread, -> { where(unread: true) }

    after_create :notify_email

    def target=(t)
      raise ModelExceptions::BadTypeNotification unless t.class == TARGET_CLASS
      super(t)
    end

    def email?
      true
    end

    def template_name
      'generic_notif'
    end

    def subject_email
      I18n.t('notif.generic.subject')
    end

    def target_class
      nil
    end

    private

    def notify_email
      return unless email?
      NotifMailer.notif_email(self.id).deliver_later
    end
  end
end