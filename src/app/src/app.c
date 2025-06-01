#include <pebble.h>
#include "strava_config.h"

static Window *window;
static TextLayer *text_layer;
static ActionBarLayer *action_bar;

enum {
  KEY_REQUEST_ACTIVITIES = 0,
  KEY_ACTIVITY_DATA = 1
};

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);
  dict_write_uint8(iter, KEY_REQUEST_ACTIVITIES, 1);
  app_message_outbox_send();
}

static void in_received_handler(DictionaryIterator *iter, void *context) {
  Tuple *activity_tuple = dict_find(iter, KEY_ACTIVITY_DATA);
  if(activity_tuple) {
    text_layer_set_text(text_layer, activity_tuple->value->cstring);
  }
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  text_layer = text_layer_create(GRect(0, 72, bounds.size.w, 100));
  text_layer_set_font(text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24_BOLD));
  text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
  
  action_bar = action_bar_layer_create();
  action_bar_layer_set_icon(action_bar, BUTTON_ID_SELECT, ICON_ACTION_ITEM);
  
  layer_add_child(window_layer, text_layer_get_layer(text_layer));
  action_bar_layer_add_to_window(action_bar, window);
}

static void init() {
  window = window_create();
  window_set_click_config_provider(window, click_config_provider);
  window_set_window_handlers(window, (WindowHandlers) {
    .load = window_load
  });
  window_stack_push(window, true);
  
  app_message_open(256, 256);
  app_message_register_inbox_received(in_received_handler);
}

static void deinit() {
  text_layer_destroy(text_layer);
  action_bar_layer_destroy(action_bar);
  window_destroy(window);
}

int main() {
  init();
  app_event_loop();
  deinit();
}