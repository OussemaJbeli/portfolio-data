-- ============================================================
--  PORTFOLIO CMS — Schema v2 (improved)
--  Multilingual: Arabic (ar) | French (fr) | English (en)
--
--  This file is GENERATED from the live database created by the
--  Laravel migrations in portfolio-back/database/migrations.
--  It is the authoritative reference for the 27 CMS tables.
--  Do not edit by hand — change a migration and re-run, then
--  regenerate with:
--    mysqldump --no-data --skip-comments --compact portfolio <tables>
--
--  WHAT CHANGED vs the original portfolio_schema.sql
--  --------------------------------------------------
--  1. IDs/FKs normalised to BIGINT UNSIGNED (Laravel id()/foreignId)
--     for consistency and guaranteed PK/FK type-matching, instead of
--     the hand-tuned TINYINT/SMALLINT/INT widths.
--  2. created_at added everywhere (Laravel timestamps()); config
--     tables previously had only updated_at.
--  3. Listing indexes added: (is_active, sort_order) on list tables,
--     idx_projects_listing (is_active, is_featured, sort_order),
--     idx_blog_active_featured, plus the original blog/message indexes.
--  4. CHECK (percentage BETWEEN 0 AND 100) on skill_categories.
--  5. Seed data (nav_items, stats) moved out of the schema into a
--     Laravel seeder (database/seeders/PortfolioSeeder.php).
--
--  KEPT (intentionally, with rationale)
--  ------------------------------------
--  * Per-language _en/_fr/_ar columns: a pragmatic, explicit choice for
--    a fixed 3-language site. (A JSON-translatable refactor is possible
--    later if more languages are needed.)
--  * Singleton "section config" tables and separate project/blog
--    category tables: clearer and keeps FK integrity per type.
--
--  NOT ENFORCED IN DB (enforce in the application layer)
--  -----------------------------------------------------
--  * blog_related: an article must not relate to itself
--    (blog_id <> related_id). MySQL 8 forbids a CHECK on columns that
--    are part of a foreign key with a referential action (error 3823),
--    and the ON DELETE/UPDATE CASCADE behaviour was kept instead.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `site_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `logo_text` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OJ.',
  `favicon_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cv_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `theme_default` enum('dark','light') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'dark',
  `lang_default` enum('ar','fr','en') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `meta_title_en` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title_fr` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title_ar` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description_en` varchar(320) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description_fr` varchar(320) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description_ar` varchar(320) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `footer_copy_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '© 2025 All rights reserved.',
  `footer_copy_fr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `footer_copy_ar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `nav_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `route_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `href` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_fr` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_ar` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nav_items_route_key_unique` (`route_key`),
  KEY `nav_items_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `hero` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `badge_en` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `badge_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `badge_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `greeting_en` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `greeting_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `greeting_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `typewriter_en` json DEFAULT NULL COMMENT '["I build modern...", "I design..."]',
  `typewriter_fr` json DEFAULT NULL,
  `typewriter_ar` json DEFAULT NULL,
  `tagline_en` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tagline_fr` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tagline_ar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cta_primary_label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Download CV',
  `cta_primary_label_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Télécharger CV',
  `cta_primary_label_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'تحميل السيرة الذاتية',
  `cta_primary_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cta_secondary_label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'View My Works',
  `cta_secondary_label_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Voir mes travaux',
  `cta_secondary_label_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عرض أعمالي',
  `cta_secondary_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code_badge` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '</>',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `social_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `platform` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_in` set('hero','about','footer','blog_author') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'hero,footer',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `social_links_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `stats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_en` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stats_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `about` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `section_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> ABOUT ME',
  `section_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> À PROPOS',
  `section_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> عني',
  `heading_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'About Me',
  `heading_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'À propos de moi',
  `heading_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عني',
  `bio_en` text COLLATE utf8mb4_unicode_ci,
  `bio_fr` text COLLATE utf8mb4_unicode_ci,
  `bio_ar` text COLLATE utf8mb4_unicode_ci,
  `photo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_en` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_fr` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_ar` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `availability_en` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Freelance / Full-time',
  `availability_fr` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Freelance / Temps plein',
  `availability_ar` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عمل حر / دوام كامل',
  `cta_label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Let''s Talk',
  `cta_label_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Contactez-moi',
  `cta_label_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'تواصل معي',
  `cta_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `about_bullets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_en` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text_fr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_ar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `about_bullets_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `technologies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `technologies_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `skill_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_en` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_fr` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_ar` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `percentage` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0-100',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `skill_categories_is_active_sort_order_index` (`is_active`,`sort_order`),
  CONSTRAINT `chk_skill_percentage` CHECK ((`percentage` between 0 and 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `skills_section` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `section_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> SKILLS',
  `section_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> COMPÉTENCES',
  `section_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> المهارات',
  `heading_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'My Skills',
  `heading_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Mes compétences',
  `heading_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'مهاراتي',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `project_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_categories_slug_unique` (`slug`),
  KEY `project_categories_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `projects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `thumbnail_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `title_en` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_fr` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_ar` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle_en` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle_fr` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle_ar` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_en` text COLLATE utf8mb4_unicode_ci,
  `description_fr` text COLLATE utf8mb4_unicode_ci,
  `description_ar` text COLLATE utf8mb4_unicode_ci,
  `about_en` text COLLATE utf8mb4_unicode_ci,
  `about_fr` text COLLATE utf8mb4_unicode_ci,
  `about_ar` text COLLATE utf8mb4_unicode_ci,
  `hero_image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_en` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_fr` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_ar` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_en` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `completed_date` date DEFAULT NULL,
  `live_demo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `github_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `projects_slug_unique` (`slug`),
  KEY `projects_category_id_foreign` (`category_id`),
  KEY `idx_projects_listing` (`is_active`,`is_featured`,`sort_order`),
  CONSTRAINT `projects_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `project_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `project_gallery` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_en` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alt_fr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alt_ar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_gallery_project_id_foreign` (`project_id`),
  CONSTRAINT `project_gallery_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `project_features` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `text_en` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text_fr` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_ar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_features_project_id_foreign` (`project_id`),
  CONSTRAINT `project_features_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `project_technologies` (
  `project_id` bigint unsigned NOT NULL,
  `technology_id` bigint unsigned NOT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`project_id`,`technology_id`),
  KEY `project_technologies_technology_id_foreign` (`technology_id`),
  CONSTRAINT `project_technologies_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `project_technologies_technology_id_foreign` FOREIGN KEY (`technology_id`) REFERENCES `technologies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `project_roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `icon_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_en` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_fr` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_ar` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body_en` text COLLATE utf8mb4_unicode_ci,
  `body_fr` text COLLATE utf8mb4_unicode_ci,
  `body_ar` text COLLATE utf8mb4_unicode_ci,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_roles_project_id_foreign` (`project_id`),
  CONSTRAINT `project_roles_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `projects_section` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `section_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> PROJECTS',
  `section_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> PROJETS',
  `section_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> المشاريع',
  `heading_part1_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'My Projects',
  `heading_part1_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Mes Projets',
  `heading_part1_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'مشاريعي',
  `subheading_en` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subheading_fr` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subheading_ar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_title_part1_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Things I''ve',
  `listing_title_part1_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Ce que j''ai',
  `listing_title_part1_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ما قمت',
  `listing_title_part2_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Built',
  `listing_title_part2_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Construit',
  `listing_title_part2_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ببنائه',
  `listing_subtitle_en` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_subtitle_fr` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_subtitle_ar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cta_label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'View All Projects',
  `cta_label_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Voir tous les projets',
  `cta_label_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عرض كل المشاريع',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blog_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_fr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_ar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `blog_categories_slug_unique` (`slug`),
  KEY `blog_categories_is_active_sort_order_index` (`is_active`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blogs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_en` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_fr` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title_ar` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `excerpt_en` text COLLATE utf8mb4_unicode_ci COMMENT 'Short description on listing cards',
  `excerpt_fr` text COLLATE utf8mb4_unicode_ci,
  `excerpt_ar` text COLLATE utf8mb4_unicode_ci,
  `body_en` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Full HTML/Markdown article body',
  `body_fr` longtext COLLATE utf8mb4_unicode_ci,
  `body_ar` longtext COLLATE utf8mb4_unicode_ci,
  `cover_image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `read_time_minutes` tinyint unsigned DEFAULT NULL,
  `views` int unsigned NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `published_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `blogs_slug_unique` (`slug`),
  KEY `idx_blog_published` (`published_at`),
  KEY `idx_blog_active_featured` (`is_active`,`is_featured`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blog_category_map` (
  `blog_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`blog_id`,`category_id`),
  KEY `blog_category_map_category_id_foreign` (`category_id`),
  CONSTRAINT `blog_category_map_blog_id_foreign` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `blog_category_map_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `blog_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blog_toc` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `blog_id` bigint unsigned NOT NULL,
  `anchor` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_en` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_fr` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_ar` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blog_toc_blog_id_foreign` (`blog_id`),
  CONSTRAINT `blog_toc_blog_id_foreign` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blog_related` (
  `blog_id` bigint unsigned NOT NULL,
  `related_id` bigint unsigned NOT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`blog_id`,`related_id`),
  KEY `blog_related_related_id_foreign` (`related_id`),
  CONSTRAINT `blog_related_blog_id_foreign` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `blog_related_related_id_foreign` FOREIGN KEY (`related_id`) REFERENCES `blogs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `blogs_section` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `section_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> BLOGS',
  `section_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> ARTICLES',
  `section_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> المقالات',
  `heading_part1_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Latest Blogs',
  `heading_part1_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Derniers Articles',
  `heading_part1_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'أحدث المقالات',
  `listing_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> MY BLOGS',
  `listing_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> MES ARTICLES',
  `listing_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> مقالاتي',
  `listing_title_part1_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Tech Insights',
  `listing_title_part1_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Aperçus Tech',
  `listing_title_part1_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'رؤى تقنية',
  `listing_title_part2_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Blogs & Tutorials.',
  `listing_title_part2_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Blogs et Tutoriels.',
  `listing_title_part2_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'مدونات ودروس.',
  `listing_subtitle_en` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_subtitle_fr` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_subtitle_ar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cta_label_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'View All Blogs',
  `cta_label_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Voir tous les articles',
  `cta_label_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عرض كل المقالات',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `author` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_en` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_fr` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_ar` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio_en` text COLLATE utf8mb4_unicode_ci,
  `bio_fr` text COLLATE utf8mb4_unicode_ci,
  `bio_ar` text COLLATE utf8mb4_unicode_ci,
  `profile_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `contact_section` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `section_badge_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> CONTACT',
  `section_badge_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> CONTACT',
  `section_badge_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '> التواصل',
  `heading_en` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Contact Me',
  `heading_fr` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Contactez-moi',
  `heading_ar` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'تواصل معي',
  `subtext_en` text COLLATE utf8mb4_unicode_ci,
  `subtext_fr` text COLLATE utf8mb4_unicode_ci,
  `subtext_ar` text COLLATE utf8mb4_unicode_ci,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_en` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_fr` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_ar` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `availability_en` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Freelance / Full-time',
  `availability_fr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Freelance / Temps plein',
  `availability_ar` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'عمل حر / دوام كامل',
  `label_name_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Your Name',
  `label_name_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Votre nom',
  `label_name_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'اسمك',
  `label_email_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Your Email',
  `label_email_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Votre e-mail',
  `label_email_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'بريدك الإلكتروني',
  `label_subject_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Subject',
  `label_subject_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sujet',
  `label_subject_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'الموضوع',
  `label_message_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Your Message',
  `label_message_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Votre message',
  `label_message_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'رسالتك',
  `label_send_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Send Message',
  `label_send_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Envoyer',
  `label_send_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'إرسال',
  `cta_banner_heading_en` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Interested in working together?',
  `cta_banner_heading_fr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Intéressé à travailler ensemble ?',
  `cta_banner_heading_ar` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'مهتم بالعمل معاً؟',
  `cta_banner_sub_en` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Let''s build something amazing together.',
  `cta_banner_sub_fr` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Construisons quelque chose d''incroyable ensemble.',
  `cta_banner_sub_ar` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'لنبني شيئًا رائعًا معًا.',
  `cta_banner_btn_en` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Contact Me →',
  `cta_banner_btn_fr` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Contactez-moi →',
  `cta_banner_btn_ar` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'تواصل معي →',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `contact_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sender_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_msg_read` (`is_read`),
  KEY `idx_msg_date` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `admin_users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('superadmin','editor') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'editor',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
