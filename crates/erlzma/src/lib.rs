///
/// TODO:
///  - add streaming
///  - avoid copying
///
extern crate rustler;
extern crate lzma;

use rustler::types::binary::{Binary, OwnedBinary};
use rustler::{Env, NifResult};
use lzma::LzmaError;

rustler::init!(
  "erlzma",
  [
    compress,
    decompress,
  ],
  load = on_load
);

pub fn on_load(_env: rustler::Env, _load_info: rustler::Term) -> bool {
  true
}

#[rustler::nif]
fn compress<'a>(env: Env<'a>, data: Binary, level: u32) -> NifResult<Binary<'a>> {
  result(env, lzma::compress(data.as_slice(), level))
}

#[rustler::nif]
fn decompress<'a>(env: Env<'a>, data: Binary) -> NifResult<Binary<'a>> {
  result(env, lzma::decompress(data.as_slice()))
}

fn result<'a>(env: Env<'a>, result: Result<Vec<u8>, LzmaError>) -> NifResult<Binary<'a>> {
  match result {
    Ok(res) =>
      Ok(vec_to_binary(env, res)),
    Err(err) =>
      Err(map_err(err))
  }
}

fn vec_to_binary<'a>(env: Env<'a>, vec: Vec<u8>) -> Binary<'a> {
  let mut binary = OwnedBinary::new(vec.len()).unwrap();
  binary.as_mut_slice().clone_from_slice(vec.as_slice());
  Binary::from_owned(binary, env)
}

fn map_err(err: LzmaError) -> rustler::Error {
  let err_str = err.to_string();
  rustler::Error::Term(Box::new(err_str))
}
