// TODO header text

typedef enum PostType {
    POST_NORMAL      = 0x01,
    POST_DELETED     = 0x02,
    POST_FAVOURITE   = 0x04
} PostType;

extern NSString * const MAIN_IMAGE_OBJ;

extern NSString * const KEY_DATE;
extern NSString * const KEY_AUTHOR;
extern NSString * const KEY_POST_URL;
extern NSString * const KEY_TITLE;
extern NSString * const KEY_IMAGE_URL;
extern NSString * const KEY_DESCRIPTION;
extern NSString * const KEY_IMAGES_COUNT;
extern NSString * const KEY_TYPE;
