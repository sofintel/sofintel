use gpui::{App, DismissEvent, EventEmitter, FocusHandle, Focusable, SharedString};
use ui::{
    ActiveTheme, Color, Context, IntoElement, Label, LabelCommon, LabelSize, ParentElement, Render,
    Styled, StyledExt, Window, div, h_flex, prelude::*, v_flex,
};
use workspace::ModalView;

/// A simple, branded "About Sofintel" dialog with clickable links to the GitHub
/// repository and the project website.
pub struct AboutSofintelModal {
    focus_handle: FocusHandle,
    title: SharedString,
    version: SharedString,
    sha: SharedString,
}

impl EventEmitter<DismissEvent> for AboutSofintelModal {}
impl ModalView for AboutSofintelModal {}

impl Focusable for AboutSofintelModal {
    fn focus_handle(&self, _cx: &App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl AboutSofintelModal {
    pub fn new(
        title: SharedString,
        version: SharedString,
        sha: SharedString,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> Self {
        Self {
            focus_handle: cx.focus_handle(),
            title,
            version,
            sha,
        }
    }

    fn dismiss(&mut self, _: &menu::Cancel, _window: &mut Window, cx: &mut Context<Self>) {
        cx.emit(DismissEvent);
    }
}

impl Render for AboutSofintelModal {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let theme = cx.theme();
        let github = "https://github.com/sofintel/sofintel";
        let website = "https://sofintel.github.io/";

        let github = github.to_string();
        let website = website.to_string();

        v_flex()
            .key_context("AboutSofintelModal")
            .on_action(cx.listener(Self::dismiss))
            .elevation_3(cx)
            .w_96()
            .overflow_hidden()
            .child(
                div()
                    .p_5()
                    .flex_col()
                    .gap_3()
                    .child(
                        div()
                            .flex_col()
                            .gap_1()
                            .child(Label::new(self.title.clone()).size(LabelSize::Large))
                            .child(
                                Label::new(format!(
                                    "{} {}",
                                    self.version,
                                    if self.sha.is_empty() {
                                        String::new()
                                    } else {
                                        format!("({})", self.sha)
                                    }
                                ))
                                .color(Color::Muted)
                                .size(LabelSize::Small),
                            ),
                    )
                    .child(
                        Label::new(
                            "Browser, editor, and terminal in one native Rust app. Built from the Zed codebase.",
                        )
                        .color(Color::Muted)
                        .size(LabelSize::Small),
                    )
                    .child(
                        h_flex()
                            .gap_3()
                            .child(
                                div()
                                    .id("about-github")
                                    .text_color(theme.colors().text_accent)
                                    .cursor_pointer()
                                    .on_click(cx.listener(move |_, _: &gpui::ClickEvent, _window, cx| {
                                        cx.open_url(&github);
                                    }))
                                    .child(Label::new("GitHub").size(LabelSize::Small)),
                            )
                            .child(
                                div()
                                    .id("about-website")
                                    .text_color(theme.colors().text_accent)
                                    .cursor_pointer()
                                    .on_click(cx.listener(move |_, _: &gpui::ClickEvent, _window, cx| {
                                        cx.open_url(&website);
                                    }))
                                    .child(Label::new("Website").size(LabelSize::Small)),
                            ),
                    ),
            )
            .child(
                h_flex()
                    .justify_end()
                    .p_2()
                    .border_t_1()
                    .border_color(theme.colors().border_variant)
                    .child(
                        div()
                            .id("about-ok")
                            .px_3()
                            .py_1()
                            .bg(theme.colors().element_background)
                            .rounded_md()
                            .text_color(theme.colors().text)
                            .cursor_pointer()
                            .on_click(cx.listener(|_, _: &gpui::ClickEvent, _window, cx| {
                                cx.emit(DismissEvent);
                            }))
                            .child(Label::new("OK").size(LabelSize::Small)),
                    ),
            )
    }
}
