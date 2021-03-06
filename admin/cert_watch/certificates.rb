require 'cert_watch/views/all'

module CertWatch
  ActiveAdmin.register Certificate, as: 'Certificate' do
    menu priority: 100

    actions :index, :new, :create, :show, :edit, :update

    config.batch_actions = false

    index do
      column :domain do |certificate|
        link_to(certificate.domain, admin_certificate_path(certificate))
      end
      column :state do |certificate|
        cert_watch_certificate_state(certificate)
      end
      column :last_renewed_at
      column :last_renewal_failed_at
      column :last_installed_at
      column :last_install_failed_at
    end

    scope :all
    scope :installed
    scope :processing
    scope :failed
    scope :abandoned

    filter :domain
    filter :last_renewed_at
    filter :provider, as: :select, collection: Certificate::PROVIDERS

    form do |f|
      f.inputs do
        f.input :domain
        f.input :public_key
        f.input :private_key
        f.input :chain
      end
      f.actions
    end

    action_item(:renew, only: :show) do
      if resource.can_renew?
        button_to(I18n.t('cert_watch.admin.certificates.renew'),
                  renew_admin_certificate_path(resource),
                  method: :post,
                  data: {
                    rel: 'renew',
                    confirm: I18n.t('cert_watch.admin.certificates.confirm_renew')
                  })
      end
    end

    action_item(:install, only: :show) do
      if resource.can_install?
        button_to(I18n.t('cert_watch.admin.certificates.install'),
                  install_admin_certificate_path(resource),
                  method: :post,
                  data: {
                    rel: 'install',
                    confirm: I18n.t('cert_watch.admin.certificates.confirm_install')
                  })
      end
    end

    member_action :renew, method: :post do
      resource = Certificate.find(params[:id])
      resource.renew
      redirect_to(admin_certificate_path(resource))
    end

    member_action :install, method: :post do
      resource = Certificate.find(params[:id])
      resource.install
      redirect_to(admin_certificate_path(resource))
    end

    show title: :domain do |certificate|
      attributes_table_for(certificate) do
        row :domain
        row :state do
          cert_watch_certificate_state(certificate)
        end
        row :created_at
        row :last_renewed_at
        row :last_renewal_failed_at
        row :last_installed_at
        row :last_install_failed_at
        row :public_key
      end
    end

    before_create do |certificate|
      certificate.provider = 'custom'
    end

    controller do
      def permitted_params
        params.permit(certificate: [:domain, :public_key, :private_key, :chain])
      end
    end
  end
end
