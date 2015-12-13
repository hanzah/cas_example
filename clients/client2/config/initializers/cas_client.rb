CasClient.setup do |client|
  client.auth_path = APP_CONFIG['cas_server_auth_path']
  client.verify_path = APP_CONFIG['cas_server_verify_path']
  client.client_id = APP_CONFIG['cas_client_id']
  client.client_secret = APP_CONFIG['cas_client_secret']
end
