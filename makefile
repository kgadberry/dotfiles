.PHONY: update
update:
	home-manager switch --flake .#myprofile --show-trace --impure
