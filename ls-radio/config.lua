Config = {}

Config.RestrictedChannels = 30 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted
Config.enableCmd = false --  /radio command should be active or not (if not you have to carry the item "radio") true / false

Config.messages = {
  ['not_on_radio'] = 'Non sei in nessuna radio',
  ['on_radio'] = 'Attualmente sei sulla frequenza: <b>',
  ['joined_to_radio'] = 'Sei entrato sulla frequenza: <b>',
  ['restricted_channel_error'] = 'Non puoi entrare in questo canale!',
  ['you_on_radio'] = 'Sei gia su questa frequenza: <b>',
  ['you_leave'] = 'Sei uscito dalla frequenza: <b>'
}
