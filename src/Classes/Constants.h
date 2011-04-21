// TODO header text

typedef enum PostType {
    POST_NORMAL      = 0x01,
    POST_DELETED     = 0x02,
    POST_FAVOURITE   = 0x04
} PostType;

extern NSString * const MAIN_IMAGE_OBJ;

extern NSString * const GD_POST_SEPARATOR;
extern NSString * const GD_ARCHIVE_POST_SEPARATOR;
extern NSString * const GD_ARCHIVE_LAST_POST_SEPARATOR;

extern NSString * const GD_ARCHIVE_DATE_START;
extern NSString * const GD_ARCHIVE_DATE_END;
extern NSString * const GD_ARCHIVE_USER_START;
extern NSString * const GD_ARCHIVE_USER_END;
extern NSString * const GD_ARCHIVE_URL_START;
extern NSString * const GD_ARCHIVE_URL_END;
extern NSString * const GD_ARCHIVE_TITLE_START;
extern NSString * const GD_ARCHIVE_TITLE_END;
extern NSString * const GD_ARCHIVE_IMG_URL_START;
extern NSString * const GD_ARCHIVE_IMG_URL_END;

extern NSString * const GD_ARCHIVE_POST_URL;

extern NSString * const GD_ARCHIVE_POST_DATE_START;
extern NSString * const GD_ARCHIVE_POST_DATE_END;
extern NSString * const GD_ARCHIVE_POST_IMGS_START;
extern NSString * const GD_ARCHIVE_POST_IMGS_END;
extern NSString * const GD_ARCHIVE_POST_PRE_URL;
extern NSString * const GD_ARCHIVE_POST_DESC_START;
extern NSString * const GD_ARCHIVE_POST_DESC_END;


extern NSString * const KEY_DATE;
extern NSString * const KEY_AUTHOR;
extern NSString * const KEY_POST_URL;
extern NSString * const KEY_TITLE;
extern NSString * const KEY_IMAGE_URL;
extern NSString * const KEY_DESCRIPTION;
extern NSString * const KEY_IMAGES_COUNT;
extern NSString * const KEY_TYPE;
