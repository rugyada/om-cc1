NAME=om-cc
VERSION=0.1.3
TRANSLATIONS=en it
bindir=/usr/bin
sysconfdir=/etc
sharedir=/usr/share
localedir=$(sharedir)/locale

all:

messages: usr/share/om-cc/translation
	xgettext -d om-cc -o usr/share/om-cc/om-cc.pot -L Shell --from-code utf-8 usr/share/om-cc/translation
	for i in $(TRANSLATIONS); do \
		msgmerge -U po/$$i.po usr/share/om-cc/om-cc.pot; \
	done

install:
	mkdir -p $(DESTDIR)$(prefix)/$(bindir)
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/$(NAME)
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/applications
	mkdir -p $(DESTDIR)$(prefix)/$(localedir)
	install -m 644 om-cc.desktop $(DESTDIR)$(prefix)/$(sharedir)/applications
	install -m 755 usr/bin/* $(DESTDIR)$(prefix)/$(bindir)
	cp -avx usr/share/$(NAME)/* $(DESTDIR)$(prefix)/$(sharedir)/$(NAME)
	@for l in $(TRANSLATIONS); do \
	mkdir -p  $(DESTDIR)$(prefix)/$(localedir)/$$l/LC_MESSAGES; \
	msgcat po/$$l.po |msgfmt -o $(DESTDIR)$(prefix)$(localedir)/$$l/LC_MESSAGES/om-cc.mo - ; \
	done

dist:
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ HEAD | xz -2vec -T0 > $(NAME)-$(VERSION).tar.xz;
	$(info $(NAME)-$(VERSION).tar.xz is ready)
