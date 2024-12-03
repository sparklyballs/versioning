blueprint:
  name: Z2M - Aqara H1(WRS-R02) - Wireless remote switch(double rocker)
  description: control using Aqara two button remote
  author: pauldcomanici
  domain: automation
  input:
    button_action_topic:
      name: zigbee2mqtt topic with action for aqara switch
      description: "zigbee2mqtt topic with action for aqara switch (example: zigbee2mqtt/0.LV1 button/action)"
      selector:
        text:
    single_left:
      name: left button - single press
      description: action to run on a single press of the left button
      default: []
      selector:
        action: {}
    double_left:
      name: left button - double press
      description: action to run on a double press of the left button
      default: []
      selector:
        action: {}
    triple_left:
      name: left button - triple press
      description: action to run on a triple press of the left button
      default: []
      selector:
        action: {}
    hold_left:
      name: left button - hold
      description: action to run when left button is held
      default: []
      selector:
        action: {}
    single_right:
      name: right button - single press
      description: action to run on a single press of the right button
      default: []
      selector:
        action: {}
    double_right:
      name: right button - double press
      description: action to run on a double press of the right button
      default: []
      selector:
        action: {}
    triple_right:
      name: right button - triple press
      description: action to run on a triple press of the right button
      default: []
      selector:
        action: {}
    hold_right:
      name: right button - hold
      description: action to run when right button is held
      default: []
      selector:
        action: {}
    single_both:
      name: both buttons - single press
      description: action to run on a single press of both buttons
      default: []
      selector:
        action: {}
    double_both:
      name: both buttons - double press
      description: action to run on a double press of both buttons
      default: []
      selector:
        action: {}
    triple_both:
      name: both buttons - triple press
      description: action to run on a triple press of both buttons
      default: []
      selector:
        action: {}
    hold_both:
      name: both buttons - hold
      description: action to run when both buttons are held
      default: []
      selector:
        action: {}

mode: restart
max_exceeded: silent

trigger:
  - platform: mqtt
    topic: !input "button_action_topic"

condition:
  - condition: state
    entity_id: input_boolean.manual_override_enabled
    state: "off"
  - condition: or
    conditions:
      - condition: numeric_state
        entity_id: zone.home
        above: 0
      - condition: state
        entity_id: input_boolean.home_guest_presence
        state: "on"

action:
  - variables:
      command: "{{ trigger.payload }}"
  - choose:
      - conditions:
        - condition: template
          value_template: "{{ command == 'single_left' }}"
        sequence: !input "single_left"
      - conditions:
        - condition: template
          value_template: "{{ command == 'double_left' }}"
        sequence: !input "double_left"
      - conditions:
        - condition: template
          value_template: "{{ command == 'triple_left' }}"
        sequence: !input "triple_left"
      - conditions:
        - condition: template
          value_template: "{{ command == 'hold_left' }}"
        sequence: !input "hold_left"
      - conditions:
        - condition: template
          value_template: "{{ command == 'single_right' }}"
        sequence: !input "single_right"
      - conditions:
        - condition: template
          value_template: "{{ command == 'double_right' }}"
        sequence: !input "double_right"
      - conditions:
        - condition: template
          value_template: "{{ command == 'triple_right' }}"
        sequence: !input "triple_right"
      - conditions:
        - condition: template
          value_template: "{{ command == 'hold_right' }}"
        sequence: !input "hold_right"
      - conditions:
        - condition: template
          value_template: "{{ command == 'single_both' }}"
        sequence: !input "single_both"
      - conditions:
        - condition: template
          value_template: "{{ command == 'double_both' }}"
        sequence: !input "double_both"
      - conditions:
        - condition: template
          value_template: "{{ command == 'triple_both' }}"
        sequence: !input "triple_both"
      - conditions:
        - condition: template
          value_template: "{{ command == 'hold_both' }}"
        sequence: !input "hold_both"
